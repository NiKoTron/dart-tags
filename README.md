# Dart Tags
A library for Dart developers.

_This library under active development! At this time it's [ALPHA quality software][alpha_quality_wiki]._

You can found sample app written with flutter framework [here][flutter_app].

## License
project under MIT [license][license]

## Changelogs

[full changelog][changelog]

- v 0.0.2
    basic support of ID3 v2.4 tags

## Usage

A simple usage example:
```dart
import 'dart:io';

import 'package:dart_tags/dart_tags.dart';

main(List<String> args) {
  TagProcessor tp = new TagProcessor();

  File f = new File(args[0]);

  tp.getTags(f).then((l) => l.forEach((f) => print(f)));
}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/NiKoTron/dart-tags/issues
[changelog]: CHANGELOG.md
[license]: LICENSE
[flutter_app]: https://github.com/NiKoTron/flug-tag
[alpha_quality_wiki]: https://en.wikipedia.org/wiki/Software_release_life_cycle#Alpha