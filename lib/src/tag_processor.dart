import 'dart:async';
import 'dart:typed_data';

import 'package:dart_tags/src/model/tag.dart';
import 'package:dart_tags/src/readers/id3v1.dart';
import 'package:dart_tags/src/readers/id3v2.dart';
import 'package:dart_tags/src/readers/reader.dart';

enum TagType { id3v1, id3v2 }

class TagProcessor {
  final Map<TagType, Reader> _readers = {
    TagType.id3v1: new ID3V1Reader(),
    TagType.id3v2: new ID3V2Reader(),
  };

  /// Returns the tags from the byte array
  Future<List<Tag>> getTagsFromByteArray(Future<List<int>> bytes,
      [List<TagType> types]) async {
    final tags = <Tag>[];

    if (types == null || types.isEmpty) {
      types = _readers.keys.toList();
    }

    for (var t in types) {
      final tag = await _readers[t].read(bytes);
      tags.add(tag);
    }

    return tags;
  }

  /// Returns the tags from the ByteData
  Future<List<Tag>> getTagsFromByteData(ByteData bytes,
      [List<TagType> types]) async {
    final tags = List<Tag>();
    final list = bytes.buffer.asUint8List().toList();
    final c = Completer<List<int>>.sync()..complete(list);

    final futura = c.future;

    if (types == null || types.isEmpty) {
      types = _readers.keys.toList();
    }

    for (var t in types) {
      final tag = await _readers[t].read(futura);
      tags.add(tag);
    }

    return tags;
  }
}
