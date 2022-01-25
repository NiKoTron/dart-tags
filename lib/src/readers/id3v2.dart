import 'dart:async';
import 'dart:convert';

import 'package:dart_tags/src/frames/frame.dart';
import 'package:dart_tags/src/frames/id3v2/id3v2_frame.dart';
import 'package:dart_tags/src/model/key_entity.dart';
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
  Future<Map<String, dynamic>> parseValues(List<int> bytes) async {
    final tags = <String, dynamic>{};

    if (Utf8Codec(allowMalformed: true).decode(bytes.sublist(0, 3)) != 'ID3') {
      return tags;
    }

    version_o2 = bytes[3];
    version_o3 = bytes[4];

    final ff = FrameFactory<ID3V2Frame>('ID3', '2.$version_o2.$version_o3');

    final flags = bytes[5];

    // ignore: unused_local_variable
    final unsync = flags & 0x80 != 0;
    // ignore: unused_local_variable
    final xheader = flags & 0x40 != 0;
    // ignore: unused_local_variable
    final experimental = flags & 0x20 != 0;

    final size = version_o2 >= 4
        ? _sizeOfSyncSafe(bytes.sublist(6, 10))
        : _sizeOf(bytes.sublist(6, 10));

    var offset = 10;

    var contin = true;

    while (contin) {
      final fr = bytes.sublist(offset);

      final frame = ff.getFrame(fr)! as ID3V2Frame;
      final m = frame.decode(fr);

      if (m?.key != null && m?.value != null) {
        if (m?.value is KeyEntity) {
          if (tags[m!.key] == null) {
            tags[m.key] = {m.value.key: m.value};
          } else {
            tags[m.key][m.value.key] = m.value;
          }
        } else {
          tags[m!.key] = m.value;
        }
      }

      offset = offset + _headerLength + (frame.header?.length ?? 0);
      contin = offset < size && (frame.header?.length ?? 0) != 0;
    }

    return tags;
  }

  // Regular 32bit int
  int _sizeOf(List<int> block) {
    assert(block.length == 4);

    var len = block[0] << 24;
    len += block[1] << 16;
    len += block[2] << 8;
    len += block[3];

    return len;
  }

  // Sync safe 32bit int
  int _sizeOfSyncSafe(List<int> block) {
    assert(block.length == 4);

    var len = block[0] << 21;
    len += block[1] << 14;
    len += block[2] << 7;
    len += block[3];

    return len;
  }
}
