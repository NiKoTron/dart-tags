## 0.0.1

- Initial version
- Supports Id3 v1.1 tags

## 0.0.2

- Basic support of ID3 v2.4 tags
    - support main frames include APIC
- TagProcessor now can get tags from file and from ByteData
- You can select which type of tag do you want to get
- Small fix in id3 v1 parser

## 0.0.3

- Removed dependency from [dart:io]
- Some API changes

## 0.0.4

- Formating sources

## 0.0.5

- Update static analyzer rules
- API Changes: AttachedPicture.imageType now returns String value .imageTypeCode return byte value

## 0.0.6

- Fixed compile-time issue

## 0.0.7

- Removed assertion in parser
- Fixed some crashes.
- Added clearing from null bytes in id3v2 and unsync bytes
- UTF16 crash fixed
- Improve stability

## 0.0.8

- added BASE64 for imageData in attached pictures
- small changes in example
- fix README formating

## 0.0.9

- added ParsingException class
- up sdk dependency in pubsec.yaml to <=3.0.0
- wrote some tests
- added stub mp3s for tests