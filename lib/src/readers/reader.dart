import 'dart:async';

import 'package:dart_tags/src/model/tag.dart';

abstract class Reader {
  final String _type;
  String _version;

  Reader(this._type, this._version);

  Future<Tag> read(Future<List<int>> bytes) async {
    var tag = new Tag();
    tag.tags = await parseValues(bytes);

    tag.type = type;
    tag.version = version;

    return tag;
  }

  get version => _version;
  get type => _type;

  Future<Map<String, String>> parseValues(Future<List<int>> bytes);
}
