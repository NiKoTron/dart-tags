import 'dart:convert';

import 'package:dart_tags/src/convert/utf16.dart';
import 'package:dart_tags/src/model/wurl.dart';

import 'id3v2_frame.dart';

/* http://id3.org/id3v2.4.0-frames
4.3.2.   User defined URL link frame

   This frame is intended for URL [URL] links concerning the audio file
   in a similar way to the other "W"-frames. The frame body consists
   of a description of the string, represented as a terminated string,
   followed by the actual URL. The URL is always encoded with ISO-8859-1
   [ISO-8859-1]. There may be more than one "WXXX" frame in each tag,
   but only one with the same description.

     <Header for 'User defined URL link frame', ID: "WXXX">
     Text encoding     $xx
     Description       <text string according to encoding> $00 (00)
     URL               <text string>
*/
class WXXXFrame extends ID3V2Frame<WURL> {
  WXXXFrame({int version = 4}) : super(version);

  @override
  WURL decodeBody(List<int> data, Encoding enc) {
    final splitIndex = enc is UTF16
        ? indexOfSplitPattern(data, [0x00, 0x00], 0)
        : data.indexOf(0x00);

    final description =
        splitIndex < 0 ? '' : enc.decode(data.sublist(0, splitIndex));
    final offset = splitIndex + (enc is UTF16 ? 2 : 1);

    final url = latin1.decode(data.sublist(offset));
    return WURL(description, url);
  }

  @override
  String get frameTag => 'WXXX';

  @override
  List<int> encode(WURL value, [String? key]) {
    final vBytes = [
      ...utf8.encode('${value.description}${utf8.decode([0x00])}'),
      ...latin1.encode(value.url)
    ];
    return [
      ...utf8.encode(frameTag),
      ...frameSizeInBytes(vBytes.length + 1),
      ...separatorBytes,
      ...vBytes
    ];
  }
}
