import 'dart:convert';

import '../../convert/utf16.dart';

import '../../model/lyrics.dart';

import 'id3v2_frame.dart';

/* http://id3.org/id3v2.4.0-frames
4.8.   Unsynchronised lyrics/text transcription

   This frame contains the lyrics of the song or a text transcription of
   other vocal activities. The head includes an encoding descriptor and
   a content descriptor. The body consists of the actual text. The
   'Content descriptor' is a terminated string. If no descriptor is
   entered, 'Content descriptor' is $00 (00) only. Newline characters
   are allowed in the text. There may be more than one 'Unsynchronised
   lyrics/text transcription' frame in each tag, but only one with the
   same language and content descriptor.

     <Header for 'Unsynchronised lyrics/text transcription', ID: "USLT">
     Text encoding        $xx
     Language             $xx xx xx
     Content descriptor   <text string according to encoding> $00 (00)
     Lyrics/text          <full text string according to encoding>
*/
class USLTFrame extends ID3V2Frame<UnSyncLyric> {
  USLTFrame({int version = 4}) : super(version);

  @override
  UnSyncLyric decodeBody(List<int> data, Encoding enc) {
    final lang = latin1.decode(data.sublist(0, 3));
    final splitIndex = enc is UTF16
        ? indexOfSplitPattern(data, [0x00, 0x00], 3)
        : data.indexOf(0x00);
    final description = enc.decode(data.sublist(3, splitIndex));
    final offset = splitIndex + (enc is UTF16 ? 2 : 1);
    final bodyBytes = data.sublist(offset);

    final body = enc.decode(bodyBytes);

    return UnSyncLyric(lang, description, body);
  }

  @override
  List<int> encode(UnSyncLyric value, [String? key]) {
    final enc = header?.encoding ?? utf8;

    return [
      ...latin1.encode(frameTag),
      ...frameSizeInBytes(value.lang.length +
          value.description.length +
          1 +
          value.lyrics.length +
          1),
      ...separatorBytes,
      ...latin1.encode(value.lang),
      ...enc.encode(value.description),
      0x00,
      ...enc.encode(value.lyrics)
    ];
  }

  @override
  String get frameTag => 'USLT';
}
