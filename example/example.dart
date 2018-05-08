import 'dart:io';

import 'package:dart_tags/dart_tags.dart';

main(List<String> args) {
  TagProcessor tp = new TagProcessor();

  File f = new File(args[0]);

  tp.getTags(f).then((l) => l.forEach((f) => print(f)));
}
