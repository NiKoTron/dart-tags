@TestOn('vm')
import 'dart:io';

import 'package:dart_tags/dart_tags.dart';
import 'package:dart_tags/src/readers/id3v1.dart';
import 'package:dart_tags/src/readers/id3v2.dart';
import 'package:dart_tags/src/writers/id3v1.dart';
import 'package:dart_tags/src/writers/id3v2.dart';
import 'package:test/test.dart';

void main() {
  File file1;
  File file2;

  setUp(() {
    file1 = new File('test/test_assets/id3v1.mp3');
    file2 = new File('test/test_assets/id3v24.mp3');
  });

  group('Writer Tests', () {
    test('generate tag block v2.4', () async {
      final tag = new Tag()
        ..tags = {
          'title': 'foo',
          'artist': 'bar',
          'album': 'baz',
          'year': '2010',
          'comment': 'lol it is a comment',
          'track': '6',
          'genre': 'Dream'
        }
        ..type = 'ID3'
        ..version = '2.4';

      final writer = new ID3V2Writer();

      final blocks = writer.write(await file1.readAsBytes(), tag);

      final r = new ID3V2Reader();
      final f = await r.read(blocks);

      expect(f, equals(tag));
    });

    test('generate tag block v1.1', () async {
      final tag = new Tag()
        ..tags = {
          'title': 'foo',
          'artist': 'bar',
          'album': 'baz',
          'year': '2010',
          'comment': 'lol it is a comment',
          'track': '6',
          'genre': 'Dream'
        }
        ..type = 'ID3'
        ..version = '1.1';

      final writer = new ID3V1Writer();

      final blocks = writer.write(await file1.readAsBytes(), tag);

      final r = new ID3V1Reader();
      final f = await r.read(blocks);

      expect(f, equals(tag));
    });
  });

  group('Reader Tests', () {
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
