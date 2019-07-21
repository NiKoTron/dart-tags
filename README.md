# Dart Tags

[![pub package](https://img.shields.io/pub/v/dart_tags.svg)](https://pub.dartlang.org/packages/dart_tags) [![Build Status](https://travis-ci.org/NiKoTron/dart-tags.svg?branch=master)](https://travis-ci.org/NiKoTron/dart-tags)

The library for parsing [ID3][id3org] tags, written in pure Dart.

You can found sample app written with flutter framework [here][flutter_app].

## License

project under MIT [license][license]

## Changelogs

[full changelog][changelog]

## 0.1.1

- added writer for custom tags (TXXX)
- added writer for attached picture (APIC tagged frame)
- update tests for TXXX and APIC writers

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

## In addition

Thanx for the [Photo][photo] by [Mink Mingle][mink_mingle] on [Unsplash][unsplash] that we using in unit tests.

[id3org]: http://id3.org/Home
[tracker]: https://github.com/NiKoTron/dart-tags/issues
[changelog]: CHANGELOG.md
[license]: LICENSE
[flutter_app]: https://github.com/NiKoTron/flug-tag
[photo]: https://unsplash.com/photos/HRyjETL87Gg
[mink_mingle]: https://unsplash.com/@minkmingle
[unsplash]: https://unsplash.com