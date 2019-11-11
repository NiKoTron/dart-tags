# Dart Tags

[![Coverage Status](https://coveralls.io/repos/github/NiKoTron/dart-tags/badge.svg?branch=master)](https://coveralls.io/github/NiKoTron/dart-tags?branch=master)
[![pub package](https://img.shields.io/pub/v/dart_tags.svg)](https://pub.dartlang.org/packages/dart_tags) [![Build Status](https://travis-ci.org/NiKoTron/dart-tags.svg?branch=master)](https://travis-ci.org/NiKoTron/dart-tags)
[![Awesome Dart](https://img.shields.io/badge/Awesome-Dart-blue.svg?longCache=true)](https://github.com/yissachar/awesome-dart#parsers)

The library for parsing [ID3][id3org] tags, written in pure Dart.

You can found sample app written with flutter framework [here][flutter_app].

## License

project under MIT [license][license]

## Changelogs

[full changelog][changelog]

## 0.2.2

- fixed an issue with wrong header calculation thanx [@frankdenouter](https://github.com/frankdenouter) and his [PR](https://github.com/NiKoTron/dart-tags/pull/10)
- added test assets v23 for reader

## 0.2.1

- fixed an issue with wrong utf16 decoding thanx [@magodo](https://github.com/magodo) and his [PR](https://github.com/NiKoTron/dart-tags/pull/9)
- wrote some additional tests

## Instalation

add dependency in pubsec.yaml

```yaml
dependencies:
  dart_tags: ^0.2.2
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

## Code of conduct

Please refer our [code of conduct](CODE_OF_CONDUCT.md).

## Features and bugs

Please feel free for feature requests and bugs at the [issue tracker][tracker].

## In addition

Thanx for contributing [@magodo](https://github.com/magodo), [@frankdenouter](https://github.com/frankdenouter)

Thanx for the [Photo][photo] by [Mink Mingle][mink_mingle] on [Unsplash][unsplash] that we using in unit tests.

[id3org]: http://id3.org/Home
[tracker]: https://github.com/NiKoTron/dart-tags/issues
[changelog]: CHANGELOG.md
[license]: LICENSE
[flutter_app]: https://github.com/NiKoTron/flug-tag
[photo]: https://unsplash.com/photos/HRyjETL87Gg
[mink_mingle]: https://unsplash.com/@minkmingle
[unsplash]: https://unsplash.com
