import 'dart:async';

import 'package:dart_tags/src/model/tag.dart';

/// Writer could just transform only tags in byte array
abstract class Writer {
  final String _type;
  String _version;

  Writer(this._type, this._version);

  void write(List<Tag> tags) async {

    Stream<int> s;

    return;
  }

  String get version => _version;
  String get type => _type;

  Future<List<int>> prepareTag(Tag tag);
}