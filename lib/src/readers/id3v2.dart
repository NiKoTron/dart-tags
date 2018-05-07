import 'dart:async';
import 'dart:convert';

import 'package:dart_tags/src/readers/reader.dart';

class ID3V2Reader extends Reader {
  final _frameShortcutsID3V2_3 = {
    "TIT2": "title",
    "TPE1": "artist",
    "TALB": "album",
    "TYER": "year",
    "COMM": "comment",
    "TRCK": "track",
    "TCON": "genre",
    "APIC": "picture",
    "USLT": "lyrics",
  };

//todo support v2.2
  final _frameShortcutsID3V2_2 = {
    "TT2": "title",
    "TP1": "artist",
    "TAL": "album",
    "TYE": "year",
    "COM": "comment",
    "TRK": "track",
    "TCO": "genre",
    "PIC": "picture",
    "ULT": "lyrics",
  };

  int version_o1 = 2;
  int version_o2;
  int version_o3;

  final HEADER_LEN = 10;

  ID3V2Reader() : super('ID3', '2.');

  get version => '$version_o1.$version_o2.$version_o3';

  @override
  Future<Map<String, String>> parseValues(Future<List<int>> bytes) async {
    var sBytes = await bytes;
    assert(utf8.decode(sBytes.sublist(0, 3)) == 'ID3');

    Map<String, String> tags = {};

    version_o2 = sBytes[3];
    version_o3 = sBytes[4];

    var flag = sBytes[5];

    var size = sBytes[6] << 0x15;
    size += sBytes[7] << 14;
    size += sBytes[8] << 7;
    size += sBytes[9];

    var offset = 10;

    var end = true;

    while (end) {
      var tag = utf8.decode(sBytes.sublist(offset, offset + 4));
      var len = sBytes[offset + 7];
      if (len > 0) {
        tags[_getTag(tag)] = utf8.decode(sBytes.sublist(
            offset + HEADER_LEN + 1, offset + HEADER_LEN + len - 1));
      }
      offset = offset + HEADER_LEN + len;
      end = offset < size;
    }

    return tags;
  }

  String _getTag(String tag) {
    return _frameShortcutsID3V2_3.keys.contains(tag)
        ? _frameShortcutsID3V2_3[tag]
        : tag;
  }
}
