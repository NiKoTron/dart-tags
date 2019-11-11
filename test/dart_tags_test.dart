@TestOn('vm')
import 'dart:io';
import 'dart:typed_data';

import 'package:dart_tags/dart_tags.dart';
import 'package:dart_tags/src/frames/id3v2/comm_frame.dart';
import 'package:dart_tags/src/model/comment.dart';
import 'package:dart_tags/src/readers/id3v1.dart';
import 'package:dart_tags/src/readers/id3v2.dart';
import 'package:dart_tags/src/writers/id3v1.dart';
import 'package:dart_tags/src/writers/id3v2.dart';
import 'package:test/test.dart';

void main() {
  File file1;
  File file2;
  File file3;
  File picture;

  const outputDir = 'test/output';

  setUp(() {
    file1 = File('test/test_assets/id3v1.mp3');
    file2 = File('test/test_assets/id3v24.mp3');
    file3 = File('test/test_assets/id3v23.mp3');
    picture = File('test/test_assets/mink-mingle-109837-unsplash.jpg');
  });

  group('Parsing exception Tests', () {
    test('Exception cause should be correct', () {
      final ex1 = ParsingException(ParsingException.byteArrayNull);
      final ex2 = ParsingException(ParsingException.byteDataNull);
      expect(ex1.cause, ParsingException.byteArrayNull);
      expect(ex2.cause, ParsingException.byteDataNull);
    });
  });

  group('V2 Frame Tests', () {
    test('COMM encode', () {
      final expected = [
        0x43,
        0x4F,
        0x4D,
        0x4D,
        0x00,
        0x00,
        0x00,
        0x15,
        0x00,
        0x00,
        0x03,
        0x65,
        0x6E,
        0x67,
        0x64,
        0x65,
        0x73,
        0x73,
        0x75,
        0x00,
        0x63,
        0x6F,
        0x6D,
        0x6D,
        0x65,
        0x6E,
        0x74,
        0x61,
        0x64,
        0x6F,
        0x72
      ];

      final frame = COMMFrame();

      final lst = frame.encode(Comment('eng', 'dessu', 'commentador'));

      expect(lst, equals(expected));
    });
    test('COMM decode', () {
      //COMM.......engdessu.commentador
      final data = [
        0x43,
        0x4F,
        0x4D,
        0x4D,
        0x00,
        0x00,
        0x00,
        0x15,
        0x00,
        0x00,
        0x03,
        0x65,
        0x6E,
        0x67,
        0x64,
        0x65,
        0x73,
        0x73,
        0x75,
        0x00,
        0x63,
        0x6F,
        0x6D,
        0x6D,
        0x65,
        0x6E,
        0x74,
        0x61,
        0x64,
        0x6F,
        0x72
      ];

      final decodeList = COMMFrame().decode(data);

      expect(decodeList.value.comment, equals('commentador'));
      expect(decodeList.value.description, equals('dessu'));
      expect(decodeList.value.lang, equals('eng'));
    });
  });

  group('Writer Tests', () {
    test('generate tag block v2.4', () async {
      final tag = Tag()
        ..tags = {
          'title': 'foo',
          'artist': 'bar',
          'album': 'baz',
          'year': '2010',
          'comment': Comment('eng', 'desc_here', 'lol it is a comment'),
          'track': '6',
          'genre': 'Dream',
          'custom': 'Just a tag',
          'picture': AttachedPicture()
            ..imageData = picture.readAsBytesSync()
            ..imageTypeCode = 0x03
            ..mime = 'image/jpeg'
            ..description = 'foo.jpg'
        }
        ..type = 'ID3'
        ..version = '2.4';

      final writer = ID3V2Writer();

      final blocks = writer.write(await file2.readAsBytes(), tag);

      final r = ID3V2Reader();
      final f = await r.read(blocks);

      expect(f.tags, equals(tag.tags));
    });

    test('generate tag block v1.1', () async {
      final tag = Tag()
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

      final writer = ID3V1Writer();

      final blocks = writer.write(await file1.readAsBytes(), tag);

      final r = ID3V1Reader();
      final f = await r.read(blocks);

      expect(f, equals(tag));
    });

    test('put blocks', () async {
      final tag1 = Tag()
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

      final tag2 = Tag()
        ..tags = {
          'title': 'foo',
          'artist': 'bar',
          'album': 'baz',
          'year': '2010',
          'comment': Comment('eng', 'desc', 'lol it is a comment'),
          'track': '6',
          'genre': 'Dream',
          'Custom': 'Just tag'
        }
        ..type = 'ID3'
        ..version = '2.4';

      final foo = await TagProcessor().putTagsToByteArray(
          Future.value([
            0x00,
            0x00,
            0x00,
            0x00,
            0x00,
            0x00,
            0x00,
            0x00,
            0x00,
            0x00,
            0x00
          ]),
          [tag1, tag2]);

      final _fr = () async => foo;

      final rdr1 = ID3V1Reader();
      final t1 = await rdr1.read(_fr());
      expect(t1.tags, equals(tag1.tags));

      final rdr2 = ID3V2Reader();
      final t2 = await rdr2.read(_fr());
      expect(t2.tags, equals(tag2.tags));
    });

    test('put null block', () async {
      final tag1 = Tag()
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

      final tag2 = Tag()
        ..tags = {
          'title': 'foo',
          'artist': 'bar',
          'album': 'baz',
          'year': '2010',
          'comment': Comment('eng', 'desc', 'lol it is a comment'),
          'track': '6',
          'genre': 'Dream',
          'Custom': 'Just tag'
        }
        ..type = 'ID3'
        ..version = '2.4';

      expect(
          () async => await TagProcessor()
              .putTagsToByteArray(Future.value(null), [tag1, tag2]),
          throwsA(predicate<Exception>((e) =>
              e is ParsingException &&
              e.cause == ParsingException.byteArrayNull)));
    });
  });

  group('Reader Tests', () {
    test('Test with file unspecified', () async {
      final foo =
          await TagProcessor().getTagsFromByteArray(file2.readAsBytes());

      expect(foo.length, equals(2));

      expect(foo[0].type, equals('ID3'));
      expect(foo[0].version, equals('1.1'));

      expect(foo[1].type, equals('ID3'));
      expect(foo[1].version, equals('2.4.0'));
    });

    test('Test with file 1.1', () async {
      final foo = await TagProcessor()
          .getTagsFromByteArray(file1.readAsBytes(), [TagType.id3v1]);

      expect(foo.length, equals(1));

      expect(foo[0].type, equals('ID3'));
      expect(foo[0].version, equals('1.1'));
    });

    test('Test with file 2.3', () async {
      final foo = await TagProcessor()
          .getTagsFromByteArray(file3.readAsBytes(), [TagType.id3v2]);

      expect(foo.length, equals(1));

      expect(foo[0].type, equals('ID3'));
      expect(foo[0].version, equals('2.3.0'));
    });

    test('Test with file 2.4', () async {
      final foo = await TagProcessor()
          .getTagsFromByteArray(file2.readAsBytes(), [TagType.id3v2]);

      expect(foo.length, equals(1));

      expect(foo[0].type, equals('ID3'));
      expect(foo[0].version, equals('2.4.0'));
    });

    test('Test with file 1.1 ByteData', () async {
      final foo = await TagProcessor().getTagsFromByteData(
          ByteData.view(file1.readAsBytesSync().buffer), [TagType.id3v1]);

      expect(foo.length, equals(1));

      expect(foo[0].type, equals('ID3'));
      expect(foo[0].version, equals('1.1'));
    });

    test('Test with file 2.4 ByteData', () async {
      final foo = await TagProcessor().getTagsFromByteData(
          ByteData.view(file2.readAsBytesSync().buffer), [TagType.id3v2]);

      expect(foo.length, equals(1));

      expect(foo[0].type, equals('ID3'));
      expect(foo[0].version, equals('2.4.0'));
    });

    test('Test on Failure', () async {
      expect(
          () async => await TagProcessor().getTagsFromByteArray(null),
          throwsA(predicate<Exception>((e) =>
              e is ParsingException &&
              e.cause == ParsingException.byteArrayNull)));
      expect(
          () async => await TagProcessor().getTagsFromByteData(null),
          throwsA(predicate<Exception>((e) =>
              e is ParsingException &&
              e.cause == ParsingException.byteDataNull)));
    });
  });

  group('Issues test', () {
    //https://github.com/NiKoTron/dart-tags/issues/4
    test(' Artist tag restriction on characters [#4]', () async {
      final artistName = 'Ilaiyaraaja, K. S. Chithra, S. P. BalasubrahmanyamT';

      final tag2 = Tag()
        ..tags = {
          'artist': artistName,
        }
        ..type = 'ID3'
        ..version = '2.4';

      final foo = await TagProcessor().putTagsToByteArray(
          Future.value([
            0x00,
            0x00,
            0x00,
            0x00,
            0x00,
            0x00,
            0x00,
            0x00,
            0x00,
            0x00,
            0x00
          ]),
          [tag2]);

      final _fr = () async => foo;

      final rdr2 = ID3V2Reader();
      final t2 = await rdr2.read(_fr());
      expect(t2.tags, equals(tag2.tags));
    });

    //https://github.com/NiKoTron/dart-tags/issues/3
    test(' Example for writing APIC tags [#3] ', () async {
      final pic1 = AttachedPicture()
        ..imageData = picture.readAsBytesSync()
        ..imageTypeCode = 0x03
        ..mime = 'image/jpeg'
        ..description = 'foo.jpg';

      final tag = Tag()
        ..tags = {'picture': pic1}
        ..type = 'ID3'
        ..version = '2.4';

      final writer = ID3V2Writer();

      final blocks = writer.write(await file2.readAsBytes(), tag);

      File('$outputDir/result.mp3')
        ..createSync(recursive: true)
        ..writeAsBytesSync(await blocks, mode: FileMode.write);
      print('check the $outputDir/result.mp3');

      final r = ID3V2Reader();
      final f = await r.read(blocks);

      final AttachedPicture pic = f.tags['picture'];

      File('$outputDir/${pic.description}.jpg')
        ..createSync(recursive: true)
        ..writeAsBytesSync(pic.imageData);

      final html =
          '<div><p>${pic.description}}</p><img src="data:${pic.mime};base64, ${pic.imageData64}" alt="Red dot" /></div>';

      File('$outputDir/${pic.description}.html')
        ..createSync(recursive: true)
        ..writeAsStringSync(html);

      print('check the $outputDir/${pic.description}.jpg');
      print('check the $outputDir/${pic.description}.html');

      expect(pic, equals(pic1));
    });
  });
}
