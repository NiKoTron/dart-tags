@TestOn('vm')

import 'dart:io';

import 'package:dart_tags/dart_tags.dart';
import 'package:test/test.dart';

void main() {
  File file1;
  File file2;

  group('Some kind of tests', () {
    setUp(() {
      file1 = new File('test/test_assets/id3v1.mp3');
      file2 = new File('test/test_assets/id3v24.mp3');
    });

    test('Test with file 1.1', () async {
      final foo = await new TagProcessor()
          .getTagsFromByteArray(file1.readAsBytes(), [TagType.id3v1]);

      expect(foo.length, equals(1));

      expect(foo[0].type, equals('ID3'));
      expect(foo[0].version, equals('1.1'));
    });

    test('Test with file 2.4', () async {
      final foo = await new TagProcessor()
          .getTagsFromByteArray(file2.readAsBytes(), [TagType.id3v2]);

      expect(foo.length, equals(1));

      expect(foo[0].type, equals('ID3'));
      expect(foo[0].version, equals('2.4.0'));
    });

    test('Test on Failure', () async {
      expect(
          () async => await new TagProcessor().getTagsFromByteArray(null),
          throwsA(predicate((e) =>
              e is ParsingException &&
              e.cause == ParsingException.byteArrayNull)));
      expect(
          () async => await new TagProcessor().getTagsFromByteData(null),
          throwsA(predicate((e) =>
              e is ParsingException &&
              e.cause == ParsingException.byteDataNull)));
    });
  });
}
