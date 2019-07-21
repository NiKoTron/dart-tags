import 'dart:async';
import 'dart:convert';

import 'package:dart_tags/src/frames/frame.dart';
import 'package:dart_tags/src/readers/reader.dart';

class ID3V2Reader extends Reader {
  // [ISO-8859-1]. Terminated with $00.
  // ignore: unused_field
  static const _latin1 = 0x00;

  // [UTF-16] encoded Unicode [UNICODE] with BOM. All strings in the same frame SHALL have the same byteorder. Terminated with $00 00. (use in future)
  // ignore: unused_field
  static const _utf16 = 0x01;

  // [UTF-16] encoded Unicode [UNICODE] without BOM. Terminated with $00 00. (use in future)
  // ignore: unused_field
  static const _utf16be = 0x02;

  // [UTF-8] encoded Unicode [UNICODE]. Terminated with $00.
  // ignore: unused_field
  static const _utf8 = 0x03;

  int get _headerLength => version_o2 > 2 ? 10 : 6;

  int version_o1 = 2;
  int version_o2 = 0;
  int version_o3 = 0;

  ID3V2Reader() : super('ID3', '2.');

  @override
  String get version => '$version_o1.$version_o2.$version_o3';

  @override
  Future<Map<String, dynamic>> parseValues(Future<List<int>> bytes) async {
    final sBytes = await bytes;
    final tags = <String, dynamic>{};

    if (Utf8Codec(allowMalformed: true).decode(sBytes.sublist(0, 3)) != 'ID3') {
      return tags;
    }

    version_o2 = sBytes[3];
    version_o3 = sBytes[4];

    final ff = FrameFactory('ID3', '2.4.0');

    final flags = sBytes[5];

    // ignore: unused_local_variable
    final unsync = flags & 0x80 != 0;
    // ignore: unused_local_variable
    final xheader = flags & 0x40 != 0;
    // ignore: unused_local_variable
    final experimental = flags & 0x20 != 0;

    final size = _sizeOf(sBytes.sublist(6, 10));

    var offset = 10;

    var end = true;

    while (end) {
      final len = _sizeOf(sBytes.sublist(offset + 4, offset + 8));
      final fr = sBytes.sublist(offset);

      final m = ff.getFrame(fr).decode(sBytes.sublist(offset));

      tags[m?.key] = m?.value;

      offset = offset + _headerLength + len;
      end = offset < size;
    }

    return tags;
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
