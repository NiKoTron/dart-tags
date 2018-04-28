import 'dart:async';

import 'package:dart_tags/src/model/tag.dart';

 abstract class Reader {

  final String _type;
  final String _version;

  Reader(this._type, this._version);

  Future<Tag> read(Future<List<int>> bytes)async {
      var tag = new Tag();
      tag.type = _type;
      tag.version = _version;
      tag.tags = await parseValues(bytes);
      return tag;
  }

  Future<Map<String, String>> parseValues(Future<List<int>> bytes);
}