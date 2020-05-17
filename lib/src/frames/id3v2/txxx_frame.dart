import 'dart:convert';
import 'package:collection/collection.dart' as collection;

import 'package:dart_tags/src/convert/utf16.dart';

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

*/
class TXXXFrame with ID3V2Frame<String> {
  @override
  String get frameTag => 'TXXX';

  @override
  MapEntry<String, String> decode(List<int> data) {
    final encoding = ID3V2Frame.getEncoding(data[ID3V2Frame.headerLength]);
    final tag = latin1.decode(data.sublist(0, 4)); //tags encoded in `latin1`

    if (!isTagValid(tag)) {
      return null;
    }

    assert(tag == frameTag);

    final len = sizeOf(data.sublist(4, 8));

    final body = data.sublist(
        ID3V2Frame.headerLength + 1, ID3V2Frame.headerLength + len);

    var splitIndex = encoding is UTF16
        ? _indexOfSplitPattern(body, [0x00, 0x00, ...encoding.bom])
        : body.indexOf(0x00);

    splitIndex = splitIndex < 0 ? 0 : splitIndex;

    return MapEntry<String, String>(
        splitIndex == 0
            ? frameTag
            : encoding.decode(body.sublist(0, splitIndex)),
        decodeBody(
            data.sublist(
                ID3V2Frame.headerLength +
                    1 +
                    splitIndex +
                    (encoding is UTF16 ? 2 : 1),
                ID3V2Frame.headerLength + len),
            encoding));
  }

  @override
  String decodeBody(List<int> data, Encoding enc) {
    return enc.decode(data);
  }

  @override
  List<int> encode(String value, [String key]) {
    final body = utf8.encode('$key${utf8.decode([0x00])}$value');
    return [
      ...utf8.encode(frameTag),
      ...frameSizeInBytes(body.length + 1),
      ...separatorBytes,
      ...body
    ];
  }

  static int _indexOfSplitPattern(List<int> list, List<int> pattern) {
    for (var i = 0; i < list.length - pattern.length; i++) {
      final l = list.sublist(i, i + pattern.length);
      if (collection.ListEquality().equals(l, pattern)) {
        return i;
      }
    }
    return -1;
  }
}
