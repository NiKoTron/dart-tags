# Dart Tags

[![pub package](https://img.shields.io/pub/v/dart_tags.svg)](https://pub.dartlang.org/packages/dart_tags) [![Build Status](https://travis-ci.org/NiKoTron/dart-tags.svg?branch=master)](https://travis-ci.org/NiKoTron/dart-tags)

The library for parsing ID3 tags, written in pure Dart.

You can found sample app written with flutter framework [here][flutter_app].

## License

project under MIT [license][license]

## Changelogs

[full changelog][changelog]

## 0.1.0

- added writers (currently v2 writer not fully implemented)
- fixed custom tags (TXXX / WXXX) reading
- wrote some rough tests for writers

## Instalation

add dependency in pubsec.yaml

```yaml
dependencies:
  dart_tags: ^0.1.0
```

## Usage

A simple usage example:

```dart
import 'dart:io';

import 'package:dart_tags/dart_tags.dart';

main(List<String> args) {
  TagProcessor tp = new TagProcessor();

  File f = new File(args[0]);
  
  tp.getTagsFromByteArray(f.readAsBytes()).then((l) => l.forEach((f) => print(f)));
}
```

### _Experimental_

And since 0.1.0 you can write some tags into the byte array:

```dart
import 'dart:io';

import 'package:dart_tags/dart_tags.dart';

main(List<String> args) {
  TagProcessor tp = new TagProcessor();

  final f = new File(args[0]);

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
    ..version = '2.4';
  
  List<int> newByteArrayWithTags = tp.putTagsToByteArray(f.readAsBytes(), [tag]);
}
```

## Features and bugs

Please feel free for feature requests and bugs at the [issue tracker][tracker].

---

[![id3v2 logo](https://pbs.twimg.com/profile_images/2267715562/9r0qrslx58wm75ejusvn_400x400.png)](http://id3.org/Home)

[tracker]: https://github.com/NiKoTron/dart-tags/issues
[changelog]: CHANGELOG.md
[license]: LICENSE
[flutter_app]: https://github.com/NiKoTron/flug-tag
