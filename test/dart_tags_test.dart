import 'dart:io';

import 'package:dart_tags/dart_tags.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    setUp(() {
      var fn = "/home/NiKoTron/Music/13033b03.mp3";
    });

    void printFileInfo(String fileName) async {
      final file = new File(fileName);
      new TagProcessor().getTagsFromByteArray(file.readAsBytes()).then((l) {
        print('FILE: $fileName');
        l.forEach((f) => print(f));
        print('\n');
      });
    }

    test('First Test', () {
      printFileInfo("/home/NiKoTron/Music/13033b03.mp3");
      expect(true, isTrue);
    });
  });
}
