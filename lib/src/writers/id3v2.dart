import 'dart:async';
import 'dart:convert';

import 'package:dart_tags/src/model/tag.dart';
import 'package:dart_tags/src/writers/writer.dart';
import 'package:dart_tags/src/frames/frame.dart';

class ID3V2Writer extends Writer {
  ID3V2Writer() : super('ID3', '2.4');

  @override
  Future<List<int>> prepareTag(Tag tag) {
    final tagsF = List<int>();

    final ff = FrameFactory('ID3', '2.4.0');

    tag.tags.forEach((k, v) => tagsF.addAll(ff.getFrame(k)?.encode(v, k)));

    final c = Completer<List<int>>.sync()
      ..complete([
        ...utf8.encode('ID3'),
        ...[0x04, 0x00, 0x00],
        ...frameSizeInBytes(tagsF.length),
        ...tagsF
      ]);

    return c.future;
  }

  /// Returns size of frame in bytes
  static List<int> frameSizeInBytes(int value) {
    assert(value <= 16777216);

    return [
      ((value & 0xFF000000) >> 21),
      ((value & 0x00FF0000) >> 14),
      ((value & 0x0000FF00) >> 7),
      ((value & 0x000000FF) >> 0)
    ];
  }

  @override
  Future<List<int>> removeExistingTag(List<int> bytes) {
    final c = Completer<List<int>>.sync();

    Utf8Codec(allowMalformed: true).decode(bytes.sublist(0, 3)) != 'ID3'
        ? c.complete(bytes)
        : c.complete(bytes.sublist(_sizeOf(bytes.sublist(6, 10))));

    return c.future;
  }

  int _sizeOf(List<int> block) {
    assert(block.length == 4);

    var len = block[0] << 21;
    len += block[1] << 14;
    len += block[2] << 7;
    len += block[3];

    return len;
  }

  @override
  List<int> combine(List<int> source, List<int> tags) {
    return [...tags, ...source];
  }
}
