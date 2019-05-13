import 'dart:convert';

import 'package:dart_tags/src/convert/utf16.dart';
import 'package:dart_tags/src/frames/frame.dart';

abstract class ID3V2Frame<T> implements Frame<T> {
  // [ISO-8859-1]. Terminated with $00.
  static const _latin1 = 0x00;

  // [UTF-16] encoded Unicode [UNICODE] with BOM. All strings in the same frame SHALL have the same byteorder. Terminated with $00 00. (use in future)
  // ignore: unused_field
  static const _utf16 = 0x01;

  // [UTF-16] encoded Unicode [UNICODE] without BOM. Terminated with $00 00. (use in future)
  // ignore: unused_field
  static const _utf16be = 0x02;

  // [UTF-8] encoded Unicode [UNICODE]. Terminated with $00.
  static const _utf8 = 0x03;

  // actually 2.2 not supported yet. it should be supported wia mixins
  static const headerLength = 10;

  final separatorBytes = [0x00, 0x00, 0x03];

  @override
  List<int> encode(T value);

  @override
  MapEntry<String, T> decode(List<int> data) {
    final encoding = getEncoding(data[headerLength]);
    final tag = encoding.decode(data.sublist(0, 4));

    assert(tag == tagFrame());

    final len = sizeOf(data.sublist(4, 8));

    final body = data.sublist(headerLength + 1, headerLength + len);

    return MapEntry<String, T>(tagFrame(), decodeBody(body, encoding));
  }

  String tagFrame();

  static Encoding getEncoding(int type) {
    switch (type) {
      case _latin1:
        return latin1;
      case _utf8:
        return Utf8Codec(allowMalformed: true);
      default:
        return UTF16();
    }
  }

  int sizeOf(List<int> block) {
    assert(block.length == 4);

    var len = block[0] << 21;
    len += block[1] << 14;
    len += block[2] << 7;
    len += block[3];

    return len;
  }

  T decodeBody(List<int> data, Encoding enc);

  List<int> frameSizeInBytes(int value) {
    final block = List<int>(4);

    block[0] = ((value & 0xFF000000) >> 21);
    block[1] = ((value & 0x00FF0000) >> 14);
    block[2] = ((value & 0x0000FF00) >> 7);
    block[3] = ((value & 0x000000FF) >> 0);

    return block;
  }

  List<int> clearFrameData(List<int> bytes) {
    if (bytes.length > 3 && bytes[0] == 0xFF && bytes[1] == 0xFE) {
      bytes = bytes.sublist(2);
    }
    return bytes.where((i) => i != 0).toList();
  }
}
