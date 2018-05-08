import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dart_tags/src/model/tag.dart';
import 'package:dart_tags/src/readers/id3v1.dart';
import 'package:dart_tags/src/readers/id3v2.dart';
import 'package:dart_tags/src/readers/reader.dart';

enum TagType { id3v1, id3v2 }

class TagProcessor {
  Map<TagType, Reader> _readers = {
    TagType.id3v1: new ID3V1Reader(),
    TagType.id3v2: new ID3V2Reader(),
  };

  Future<List<Tag>> getTagsFromFile(File file, [List<TagType> types]) async {
    assert(file.existsSync());
    assert(file.statSync().type == FileSystemEntityType.FILE);

    List<Tag> tags = [];

    if (types == null || types.length == 0) {
      types = _readers.keys.toList();
    }

    for (var t in types) {
      var r = await _readers[t].read(file.readAsBytes());
      tags.add(r);
    }

    return tags;
  }

  Future<List<Tag>> getTagsFromBytes(ByteData bytes,
      [List<TagType> types]) async {
    List<Tag> tags = [];
    var list = bytes.buffer.asUint8List().toList();
    Completer<List<int>> c = new Completer.sync()..complete(list);

    Future<List<int>> futura = c.future;

    if (types == null || types.length == 0) {
      types = _readers.keys.toList();
    }

    for (var t in types) {
      var r = await _readers[t].read(futura);
      tags.add(r);
    }

    return tags;
  }
}
