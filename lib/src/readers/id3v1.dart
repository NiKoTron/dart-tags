import 'dart:async';
import 'dart:convert';

import 'package:dart_tags/src/model/consts.dart' as consts;
import 'package:dart_tags/src/readers/reader.dart';

class ID3V1Reader extends Reader {
  ID3V1Reader() : super('ID3', '1.1');

  @override
  Future<Map<String, dynamic>> parseValues(List<int> bytes) async {
    final tagMap = <String, String>{};

    if (bytes.length < 128) {
      return tagMap;
    }

    bytes = bytes.sublist(bytes.length - 128);

    if (latin1.decode(bytes.sublist(0, 3)) == 'TAG') {
      tagMap['title'] = latin1.decode(_clearZeros(bytes.sublist(3, 33)));
      tagMap['artist'] = latin1.decode(_clearZeros(bytes.sublist(33, 63)));
      tagMap['album'] = latin1.decode(_clearZeros(bytes.sublist(63, 93)));
      tagMap['year'] = latin1.decode(_clearZeros(bytes.sublist(93, 97)));

      final flag = bytes[125];

      if (flag == 0) {
        tagMap['comment'] = latin1.decode(_clearZeros(bytes.sublist(97, 125)));
        tagMap['track'] = bytes[126].toString();
      }

      final id = bytes[127];
      tagMap['genre'] = id > consts.id3v1generes.length - 1 || id < 0
          ? ''
          : consts.id3v1generes[id];
    }

    return tagMap;
  }

  List<int> _clearZeros(List<int> zeros) {
    return zeros.where((i) => i != 0).toList();
  }
}
