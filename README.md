# Dart Tags

[![pub package](https://img.shields.io/pub/v/dart_tags.svg)](https://pub.dartlang.org/packages/dart_tags)

The library for parsing ID3 tags, written in pure Dart.

_This library under active development! With all the consequences._

You can found sample app written with flutter framework [here][flutter_app].

## License
project under MIT [license][license]

## Changelogs

[full changelog][changelog]

## 0.0.9
- added ParsingException class
- up sdk dependency in pubsec.yaml to <=3.0.0
- wrote some tests
- added stub mp3s for tests

## Instalation

add dependency in pubsec.yaml

```yaml
dependencies:
  dart_tags: ^0.0.9
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
