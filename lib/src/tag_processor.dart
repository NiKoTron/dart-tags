import 'dart:async';
import 'dart:typed_data';

import 'package:dart_tags/src/model/tag.dart';
import 'package:dart_tags/src/readers/id3v1.dart';
import 'package:dart_tags/src/readers/id3v2.dart';
import 'package:dart_tags/src/readers/reader.dart';

enum TagType { id3v1, id3v2 }

class ParsingException implements Exception {
  static const byteDataNull = "Byte data can't be null";
  static const byteArrayNull = "Byte array can't be null";

  String cause;
  ParsingException(this.cause);
}

class TagProcessor {
  final Map<TagType, Reader> _readers = {
    TagType.id3v1: new ID3V1Reader(),
    TagType.id3v2: new ID3V2Reader(),
  };

  /// Returns the tags from the byte array
  Future<List<Tag>> getTagsFromByteArray(Future<List<int>> bytes,
      [List<TagType> types]) async {
    if (bytes == null) {
      throw new ParsingException(ParsingException.byteArrayNull);
    }

    final tags = <Tag>[];

    if (types == null || types.isEmpty) {
      types = _readers.keys.toList();
    }

    for (var t in types) {
      tags.add(await _readers[t].read(bytes));
    }

    return tags;
  }

  /// Returns the tags from the ByteData
  Future<List<Tag>> getTagsFromByteData(ByteData bytes,
      [List<TagType> types]) async {
    if (bytes == null) {
      throw new ParsingException(ParsingException.byteDataNull);
    }

    final tags = List<Tag>();
    final c = Completer<List<int>>.sync()
      ..complete(bytes.buffer.asUint8List().toList());

    if (types == null || types.isEmpty) {
      types = _readers.keys.toList();
    }

    for (var t in types) {
      tags.add(await _readers[t].read(c.future));
    }

    return tags;
  }
}
