import 'dart:async';
import 'dart:convert';

import 'package:dart_tags/src/convert/utf16.dart';
import 'package:dart_tags/src/frames/frame.dart';
import 'package:dart_tags/src/frames/id3v2/apic_frame.dart';
import 'package:dart_tags/src/model/consts.dart' as consts;
import 'package:dart_tags/src/model/attached_picture.dart';
import 'package:dart_tags/src/readers/reader.dart';

class ID3V2Reader extends Reader {
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
      final encoding = _getEncoding(sBytes[offset + _headerLength]);
      final tag = encoding.decode(sBytes.sublist(offset, offset + 4));

      final len = _sizeOf(sBytes.sublist(offset + 4, offset + 8));

      final m =
          ff.getFrame(sBytes.sublist(offset)).decode(sBytes.sublist(offset));
      tags[m.key] = m.value;

      offset = offset + _headerLength + len;
      end = offset < size;
    }

    return tags;
  }

  List<int> _clearFrameData(List<int> bytes) {
    if (bytes.length > 3 && bytes[0] == 0xFF && bytes[1] == 0xFE) {
      bytes = bytes.sublist(2);
    }
    return bytes.where((i) => i != 0).toList();
  }

  int _sizeOf(List<int> block) {
    assert(block.length == 4);

    var len = block[0] << 21;
    len += block[1] << 14;
    len += block[2] << 7;
    len += block[3];

    return len;
  }

  Encoding _getEncoding(int type) {
    switch (type) {
      case _latin1:
        return latin1;
      case _utf8:
        return Utf8Codec(allowMalformed: true);
      default:
        return UTF16();
    }
  }

  String _getTag(String tag) {
    return consts.frameHeaderShortcutsID3V2_3.containsKey(tag)
        ? consts.frameHeaderShortcutsID3V2_3[tag]
        : tag;
  }

  bool _isValidTag(String tag) {
    return consts.framesHeaders.containsKey(tag);
  }

  AttachedPicture _parsePicture(List<int> sublist, Encoding enc) {
    final iterator = sublist.iterator;
    var buff = <int>[];

    final attachedPicture = AttachedPicture();

    var cont = 0;

    while (iterator.moveNext() && cont < 4) {
      final crnt = iterator.current;
      if (crnt == 0x00 && cont < 3) {
        if (cont == 1 && buff.isNotEmpty) {
          attachedPicture.imageTypeCode = buff[0];
          cont++;
          attachedPicture.description = enc.decode(buff.sublist(1));
        } else {
          attachedPicture.mime = enc.decode(buff);
        }
        buff = [];
        cont++;
        continue;
      }
      buff.add(crnt);
    }

    attachedPicture.imageData = buff;

    return attachedPicture;
  }
}
