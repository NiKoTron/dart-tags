import 'dart:async';

import 'package:dart_tags/src/model/tag.dart';

abstract class Reader {
  final String _type;
  final String _version;

  Reader(this._type, this._version);

  Future<Tag> read(Future<List<int>> bytes) {
    final c = Completer<Tag>();
    bytes.then((b) => parseValues(b).then((tags) {
          final tag = Tag()
            ..tags = tags
            ..type = type
            ..version = version;
          c.complete(tag);
        }));
    return c.future;
  }

  Future<Tag> readBytes(List<int> bytes) {
    final c = Completer<Tag>();
    parseValues(bytes).then((tags) {
      final tag = Tag()
        ..tags = tags
        ..type = type
        ..version = version;
      c.complete(tag);
    });
    return c.future;
  }

  String get version => _version;
  String get type => _type;

  Future<Map<String, dynamic>> parseValues(List<int> bytes);
}
