import 'dart:io';

import 'package:dart_tags/dart_tags.dart';

void main(List<String> args) {
  final tp = new TagProcessor();

  final f = new File(args[0]);

  tp
      .getTagsFromByteArray(f.readAsBytes())
      .then((l) => l.forEach((f) => print(f)));
}
