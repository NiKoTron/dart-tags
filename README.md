# Dart Tags

[![Coverage Status](https://coveralls.io/repos/github/NiKoTron/badge.svg?branch=master)](https://coveralls.io/github/NiKoTron/dart-tags?branch=master)
[![pub package](https://img.shields.io/pub/v/dart_tags.svg)](https://pub.dartlang.org/packages/dart_tags) [![Build Status](https://travis-ci.org/NiKoTron/dart-tags.svg?branch=master)](https://travis-ci.org/NiKoTron/dart-tags)
[![Awesome Dart](https://img.shields.io/badge/Awesome-Dart-blue.svg?longCache=true)](https://github.com/yissachar/awesome-dart#parsers)
[![MIT](https://img.shields.io/github/license/NiKoTron/dart-tags)](LICENSE)

The library for parsing [ID3](https://id3.org/Home) tags, written in pure Dart.

You can found sample app written with flutter framework [here](https://github.com/NiKoTron/flug-tag).

## License

project under MIT [license](LICENSE)

## Changelogs

[full changelog](CHANGELOG.md)

## 0.3.0+1

* hotfix! missed exports for new tags was added

## 0.3.0 (BREAKING CHANGES)

* COMM, APIC, USLT, WXXX tags returns as a map
* WXXX frame returns WURL object
* various fixes
* added USLT tag
* added possibility to pass many COMM, APIC, USLT tags
* APIC processing was refactored
* hex encoder
* unrecognized encoding falls to hex encoder (removed unsupported encoding error)
* unsupported tags like PRIV will be printed just like raw binary data

## Instalation

add dependency in pubsec.yaml

``` yaml
dependencies:
  dart_tags: ^0.3.0
```

## Usage

A simple usage example:

``` dart
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

Please feel free for feature requests and bugs at the [issue tracker](https://github.com/NiKoTron/issues).

## In addition

Thanx for contributing [@magodo](https://github.com/magodo), [@frankdenouter](https://github.com/frankdenouter)

Thanx for the [Photo](https://unsplash.com/photos/HRyjETL87Gg) by [Mink Mingle](https://unsplash.com/@minkmingle) on [Unsplash](https://unsplash.com) that we using in unit tests.