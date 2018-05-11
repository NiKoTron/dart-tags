import 'dart:async';

import 'package:dart_tags/src/model/tag.dart';

abstract class Reader {
  final String _type;
  String _version;

  Reader(this._type, this._version);

  Future<Tag> read(Future<List<int>> bytes) async {
    final tag = new Tag()
      ..tags = await parseValues(bytes)
      ..type = type
      ..version = version;

    return tag;
  }

  String get version => _version;
  String get type => _type;

  Future<Map<String, dynamic>> parseValues(Future<List<int>> bytes);
}
