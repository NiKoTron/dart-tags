import 'dart:io';

import 'package:dart_tags/dart_tags.dart';

void main(List<String> args) {
  new Directory(args[0])
      .list(recursive: true, followLinks: false)
      .listen((FileSystemEntity entity) {
    if (entity.statSync().type == FileSystemEntityType.file &&
        entity.path.endsWith('.mp3')) {
      printFileInfo(entity.path);
    }
  });
}

void printFileInfo(String fileName) async {
  final file = new File(fileName);
  new TagProcessor().getTagsFromByteArray(file.readAsBytes()).then((l) {
    print('FILE: $fileName');
    l.forEach((f) => print(f));
    print('\n');
  });
}
