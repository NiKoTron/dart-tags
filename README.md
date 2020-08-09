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

## 0.3.0 (BREAKING CHANGES)

- COMM, APIC, USLT, WXXX tags returns as a map
- WXXX frame returns WURL object
- various fixes
- added USLT tag
- added possibility to pass many COMM, APIC, USLT tags
- APIC processing was refactored
- hex encoder
- unrecognized encoding falls to hex encoder (removed unsupported encoding error)
- unsupported tags like PRIV will be printed just like raw binary data


## 0.2.3

- Fixed wrong utf16 decoding. issue [issue #13](https://github.com/NiKoTron/dart-tags/issues/13))

## Instalation

add dependency in pubsec.yaml

```yaml
dependencies:
  dart_tags: ^0.3.0
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

[id3org]: https://id3.org/Home
[tracker]: https://github.com/NiKoTron/dart-tags/issues
[changelog]: CHANGELOG.md
[license]: LICENSE
[flutter_app]: https://github.com/NiKoTron/flug-tag
[photo]: https://unsplash.com/photos/HRyjETL87Gg
[mink_mingle]: https://unsplash.com/@minkmingle
[unsplash]: https://unsplash.com
