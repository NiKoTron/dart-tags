import 'dart:async';
import 'dart:convert';

import 'package:dart_tags/src/model/tag.dart';
import 'package:dart_tags/src/writers/writer.dart';

class ID3V2Writer extends Writer {
  ID3V2Writer() : super('ID3', '2.4');

  @override
  Future<List<int>> prepareTag(Tag tag) {
        final b = new List<int>()
      ..addAll(utf8.encode('TAG'));


    final c = Completer<List<int>>.sync()..complete(b);

    return c.future;
  }

  @override
  Future<List<int>> removeExistingTag(List<int> bytes) {
    final c = new Completer<List<int>>.sync();

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
}
