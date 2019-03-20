import 'dart:async';
import 'dart:convert';

import 'package:dart_tags/src/model/consts.dart' as consts;
import 'package:dart_tags/src/readers/reader.dart';

class ID3V1Reader extends Reader {
  ID3V1Reader() : super('ID3', '1.1');

  @override
  Future<Map<String, dynamic>> parseValues(Future<List<int>> bytes) async {
    var sBytes = await bytes;
    final tagMap = <String, String>{};

    if (sBytes.length < 128) {
      return tagMap;
    }

    sBytes = sBytes.sublist(sBytes.length - 128);

    if (latin1.decode(sBytes.sublist(0, 3)) == 'TAG') {
      tagMap['title'] = latin1.decode(_clearZeros(sBytes.sublist(3, 33)));
      tagMap['artist'] = latin1.decode(_clearZeros(sBytes.sublist(33, 63)));
      tagMap['album'] = latin1.decode(_clearZeros(sBytes.sublist(63, 93)));
      tagMap['year'] = latin1.decode(_clearZeros(sBytes.sublist(93, 97)));

      final flag = sBytes[125];

      if (flag == 0) {
        tagMap['comment'] = latin1.decode(_clearZeros(sBytes.sublist(97, 125)));
        tagMap['track'] = sBytes[126].toString();
      }

      final id = sBytes[127];
      tagMap['genre'] =
          id > consts.id3v1generes.length - 1 ? '' : consts.id3v1generes[id];
    }

    return tagMap;
  }

  List<int> _clearZeros(List<int> zeros) {
    return zeros.where((i) => i != 0).toList();
  }
}
