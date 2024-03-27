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

## 0.4.1

* thanx to [@antitim](https://github.com/antitim) for find and reslove issue with a broken images in the tags in this [PR]
* dependencies update

## 0.4.0 (Null Safety)

* thanx for migrating to null safety to [@timekone](https://github.com/timekone) and this [PR](https://github.com/NiKoTron/dart-tags/pull/35)
* updated some dependencies

## 0.3.1

* implemented separate getting size of frame for id3 v2.3 and v2.4
* added test case and asset
* fixed typos, thanx to [@algoshipda](https://github.com/algoshipda) and his [PR](https://github.com/NiKoTron/dart-tags/pull/17)
* fixed APIC picture type error, thanx to [@algoshipda](https://github.com/algoshipda) and his [PR](https://github.com/NiKoTron/dart-tags/pull/20)

## Instalation

add dependency in pubsec.yaml

``` yaml
dependencies:
  dart_tags: ^0.4.0
```

## Usage

A simple usage example:

``` dart
import 'dart:io';

import 'package:dart_tags/dart_tags.dart';

main(List<String> args) {
  final tp = new TagProcessor();

  final f = new File(args[0]);

  tp.getTagsFromByteArray(f.readAsBytes()).then((l) => l.forEach((f) => print(f)));
}
```

## Code of conduct

Please refer our [code of conduct](CODE_OF_CONDUCT.md).

## Features and bugs

Please feel free for feature requests and bugs at the [issue tracker](https://github.com/NiKoTron/issues).

## In addition

Thanx for contributing [@magodo](https://github.com/magodo), [@frankdenouter](https://github.com/frankdenouter) [@algoshipda](https://github.com/algoshipda) [@timekone](https://github.com/timekone)

Thanx for the [Photo](https://unsplash.com/photos/HRyjETL87Gg) by [Mink Mingle](https://unsplash.com/@minkmingle) on [Unsplash](https://unsplash.com) that we using in unit tests.
