import 'dart:async';
import 'dart:io';

import 'package:dart_tags/src/model/tag.dart';
import 'package:dart_tags/src/readers/id3v1.dart';

class TagProcessor {
  Future<List<Tag>> getTags(File file) async {
    assert(file.existsSync());
    assert(file.statSync().type == FileSystemEntityType.FILE);

    List<Tag> tags = [];

    ID3V1Reader id3v1 = new ID3V1Reader();
    tags.add(await id3v1.read(file.readAsBytes()));
    return tags;
  }
}
