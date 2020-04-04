import 'dart:async';
import 'dart:convert';

import 'package:dart_tags/src/model/consts.dart' as consts;
import 'package:dart_tags/src/model/tag.dart';
import 'package:dart_tags/src/writers/writer.dart';

class ID3V1Writer extends Writer {
  ID3V1Writer() : super('ID3', '1.1');

  @override
  Future<List<int>> prepareTag(Tag tag) {
    final b = <int>[
      ...(latin1.encode('TAG')),
      ...(_filledArray(tag.tags.containsKey('title') ? tag.tags['title'] : '')),
      ...(_filledArray(
          tag.tags.containsKey('artist') ? tag.tags['artist'] : '')),
      ...(_filledArray(tag.tags.containsKey('album') ? tag.tags['album'] : '')),
      ...(_filledArray(
          tag.tags.containsKey('year') ? tag.tags['year'] : '', 4)),
      ...(_filledArray(
          tag.tags.containsKey('comment') ? tag.tags['comment'] : '', 28)),
      (0),
      (tag.tags.containsKey('track') ? int.parse(tag.tags['track']) : 0),
      (consts.id3v1generes.indexOf(tag.tags['genre']))
    ];

    final c = Completer<List<int>>.sync()..complete(b);

    return c.future;
  }

  List<int> _filledArray(String inputString, [int thrs = 30]) {
    final s = inputString.length > thrs
        ? inputString.substring(0, thrs)
        : inputString;
    return latin1.encode(s).toList()..addAll(List.filled(thrs - s.length, 0));
  }

  @override
  Future<List<int>> removeExistingTag(List<int> bytes) {
    final c = Completer<List<int>>.sync();

    bytes.length < 128 ||
            latin1.decode(
                    bytes.sublist(bytes.length - 128, bytes.length - 125)) !=
                'TAG'
        ? c.complete(bytes)
        : c.complete(bytes.sublist(0, bytes.length - 128));

    return c.future;
  }

  @override
  List<int> combine(List<int> source, List<int> tags) {
    return List<int>.from(source)..addAll(tags);
  }
}
