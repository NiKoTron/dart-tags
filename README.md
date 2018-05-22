# Dart Tags

[![pub package](https://img.shields.io/pub/v/dart_tags.svg)](https://pub.dartlang.org/packages/dart_tags)

The library for parsing ID3 tags, written in pure Dart.

_This library under active development! With all the consequences._

You can found sample app written with flutter framework [here][flutter_app].

## License
project under MIT [license][license]

## Changelogs

[full changelog][changelog]

- v0.0.8
  - added BASE64 for imageData in attached pictures
  - .toString() now returns JSON
  - small changes in example
  - fix README formating

## Instalation

add dependency in pubsec.yaml

```yaml
dependencies:
  dart_tags: ^0.0.8
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

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/NiKoTron/dart-tags/issues
[changelog]: CHANGELOG.md
[license]: LICENSE
[flutter_app]: https://github.com/NiKoTron/flug-tag
