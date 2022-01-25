import 'dart:convert';

import '../../convert/utf16.dart';

import 'id3v2_frame.dart';

/* http://id3.org/id3v2.4.0-frames
4.2.   Text information frames

   The text information frames are often the most important frames,
   containing information like artist, album and more. There may only be
   one text information frame of its kind in an tag. All text
   information frames supports multiple strings, stored as a null
   separated list, where null is reperesented by the termination code
   for the charater encoding. All text frame identifiers begin with "T".
   Only text frame identifiers begin with "T", with the exception of the
   "TXXX" frame. All the text information frames have the following
   format:

     <Header for 'Text information frame', ID: "T000" - "TZZZ",
     excluding "TXXX" described in 4.2.6.>
     Text encoding                $xx
     Information                  <text string(s) according to encoding>

4.2.6.   User defined text information frame

   This frame is intended for one-string text information concerning the
   audio file in a similar way to the other "T"-frames. The frame body
   consists of a description of the string, represented as a terminated
   string, followed by the actual string. There may be more than one
   "TXXX" frame in each tag, but only one with the same description.

     <Header for 'User defined text information frame', ID: "TXXX">
     Text encoding     $xx
     Description       <text string according to encoding> $00 (00)
     Value             <text string according to encoding>

*/
class TXXXFrame extends ID3V2Frame<String> {
  TXXXFrame({int version = 4}) : super(version);

  @override
  String get frameTag => 'TXXX';

  String? _customTagName;

  @override
  MapEntry<String, String> decode(List<int> data) {
    final entry = super.decode(data)!;
    return MapEntry<String, String>(_customTagName ?? frameTag, entry.value);
  }

  @override
  String decodeBody(List<int> data, Encoding enc) {
    final splitIndex = enc is UTF16
        ? indexOfSplitPattern(data, [0x00, 0x00], 0)
        : data.indexOf(0x00);

    _customTagName = enc.decode(data.sublist(0, splitIndex));
    final offset = splitIndex + (enc is UTF16 ? 2 : 1);

    final body = enc.decode(data.sublist(offset));
    return body;
  }

  @override
  List<int> encode(String value, [String? key]) {
    final body = utf8.encode('$key${utf8.decode([0x00])}$value');
    return [
      ...utf8.encode(frameTag),
      ...frameSizeInBytes(body.length + 1),
      ...separatorBytes,
      ...body
    ];
  }
}
