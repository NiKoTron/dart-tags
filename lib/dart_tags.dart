/// The library helps to gets tags from mp3 files.
///
/// At this time lib supports ID3 v1.1 and v2.4 tags
///
/// Example usages:
/// ```dart
/// import 'dart:io';
///
/// import 'package:dart_tags/dart_tags.dart';
///
/// main(List<String> args) {
///   TagProcessor tp = new TagProcessor();
///
///   File f = new File(args[0]);
///
///   tp.getTagsFromByteArray(f.readAsBytes()).then((l) => l.forEach((f) => print(f)));
/// }
/// ```
library dart_tags;

export 'src/tag_processor.dart';
export 'src/model/attached_picture.dart';
export 'src/model/tag.dart';
export 'src/model/comment.dart';
export 'src/model/lyrics.dart';
export 'src/model/wurl.dart';
