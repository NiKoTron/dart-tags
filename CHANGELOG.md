## 0.4.0 (Null Safety)

* thanx for migrating to null safety to [@timekone](https://github.com/timekone) and this [PR](https://github.com/NiKoTron/dart-tags/pull/35)
* updated some dependencies

## 0.3.1

* implemented separate getting size of frame for id3 v2.3 and v2.4
* added test case and asset
* fixed typos, thanx to [@algoshipda](https://github.com/algoshipda) and his [PR](https://github.com/NiKoTron/dart-tags/pull/17)
* fixed APIC picture type error, thanx to [@algoshipda](https://github.com/algoshipda) and his [PR](https://github.com/NiKoTron/dart-tags/pull/20)

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

## 0.2.3

* Fixed issue [issue #13](https://github.com/NiKoTron/dart-tags/issues/13))
* Updated pedantic rules up to 1.9.0

## 0.2.2

* fixed an issue with wrong header calculation thanx [@frankdenouter](https://github.com/frankdenouter) and his [PR](https://github.com/NiKoTron/dart-tags/pull/10)
* added test assets v23 for reader

## 0.2.1

* fixed an issue with wrong utf16 decoding thanx [@magodo](https://github.com/magodo) and his [PR](https://github.com/NiKoTron/dart-tags/pull/9)
* wrote some additional tests

## 0.2.0

* added separate frame processing [Framer API](FRAMER.md)
* update tests (added test for [issue #4](https://github.com/NiKoTron/dart-tags/issues/4))
* fixed empty tag exception for id3v1
* added [CoC](CODE_OF_CONDUCT.md)
* fixed writing APIC tag [issue #3](https://github.com/NiKoTron/dart-tags/issues/3)

## 0.1.2 (HotFix)

* rise limmit of tag according to the [issue #3](https://github.com/NiKoTron/dart-tags/issues/3)

## 0.1.1

* added writer for custom tags (TXXX)
* added writer for attached picture (APIC tagged frame)
* update tests for TXXX and APIC writers

## 0.1.0

* added writers (currently v2 writer not fully implemented)
* fixed custom tags (TXXX / WXXX) reading
* wrote some rough tests for writers

## 0.0.9

* added ParsingException class
* up sdk dependency in pubsec.yaml to <=3.0.0
* wrote some tests
* added stub mp3s for tests

## 0.0.8

* added BASE64 for imageData in attached pictures
* small changes in example
* fix README formating

## 0.0.7

* Removed assertion in parser
* Fixed some crashes.
* Added clearing from null bytes in id3v2 and unsync bytes
* UTF16 crash fixed
* Improve stability

## 0.0.6

* Fixed compile-time issue

## 0.0.5

* Update static analyzer rules
* API Changes: AttachedPicture.imageType now returns String value .imageTypeCode return byte value

## 0.0.4

* Formating sources

## 0.0.3

* Removed dependency from [dart:io]
* Some API changes

## 0.0.2

* Basic support of ID3 v2.4 tags
* support main frames include APIC
* TagProcessor now can get tags from file and from ByteData
* You can select which type of tag do you want to get
* Small fix in id3 v1 parser

## 0.0.1

* Initial version
* Supports Id3 v1.1 tags
