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

    final block = List<int>(4);
    final sevenBitMask = 0x7f;

    block[0] = (value >> 21) & sevenBitMask;
    block[1] = (value >> 14) & sevenBitMask;
    block[2] = (value >> 7) & sevenBitMask;
    block[3] = (value >> 0) & sevenBitMask;

    return block;
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
