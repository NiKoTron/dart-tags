import 'dart:async';
import 'dart:typed_data';

import 'package:dart_tags/src/model/tag.dart';
import 'package:dart_tags/src/readers/id3v1.dart';
import 'package:dart_tags/src/readers/id3v2.dart';
import 'package:dart_tags/src/readers/reader.dart';
import 'package:dart_tags/src/writers/id3v1.dart';
import 'package:dart_tags/src/writers/id3v2.dart';
import 'package:dart_tags/src/writers/writer.dart';

enum TagType { unknown, id3v1, id3v2 }

class ParsingException implements Exception {
  static const byteDataNull = 'Byte data can\'t be null';
  static const byteArrayNull = 'Byte array can\'t be null';

  final cause;
  ParsingException(this.cause);

  @override
  String toString() => '$runtimeType: $cause \n\t ${super.toString()}';
}

class TagProcessor {
  final Map<TagType, Reader> _readers = {
    TagType.id3v1: ID3V1Reader(),
    TagType.id3v2: ID3V2Reader(),
  };

  final Map<TagType, Writer> _writers = {
    TagType.id3v1: ID3V1Writer(),
    TagType.id3v2: ID3V2Writer(),
  };

  static TagType getTagType(String type, String version) {
    if (type.toLowerCase() == 'id3') {
      switch (version.substring(0, 1)) {
        case '1':
          return TagType.id3v1;
        case '2':
          return TagType.id3v2;
        default:
          return TagType.unknown;
      }
    }
    return TagType.unknown;
  }

  /// Returns the tags from the byte array
  Future<List<Tag>> getTagsFromByteArray(Future<List<int>> bytes,
      [List<TagType> types]) async {
    if (await bytes == null) {
      throw ParsingException(ParsingException.byteArrayNull);
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
      throw ParsingException(ParsingException.byteDataNull);
    }

    final tags = <Tag>[];
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

  Future<List<int>> putTagsToByteArray(Future<List<int>> bytes,
      [List<Tag> tags]) async {
    if (await bytes == null) {
      throw ParsingException(ParsingException.byteArrayNull);
    }
    var b = await bytes;

    if (tags == null || tags.isEmpty) {
      for (var w in _writers.values) {
        b = await w.removeExistingTag(b);
      }

      return b;
    }

    for (var t in tags) {
      final w = _writers[getTagType(t.type, t.version)];
      b = await w.write(b, t);
    }

    return b;
  }
}
