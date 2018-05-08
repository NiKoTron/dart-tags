import 'dart:io';

import 'package:dart_tags/dart_tags.dart';

main(List<String> args) {
  TagProcessor tp = new TagProcessor();

  //File f = new File(args[0]);

  File f = new File('/home/NiKoTron/git/tag_flu/data/mp3.mp3');

  tp.getTagsFromFile(f).then((l) => l.forEach((f) => print(f)));
}
