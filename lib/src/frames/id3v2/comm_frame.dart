import 'dart:convert';

import 'package:dart_tags/src/model/comment.dart';

import 'id3v2_frame.dart';

/* http://id3.org/id3v2.4.0-frames
4.10.   Comments

   This frame is intended for any kind of full text information that
   does not fit in any other frame. It consists of a frame header
   followed by encoding, language and content descriptors and is ended
   with the actual comment as a text string. Newline characters are
   allowed in the comment text string. There may be more than one
   comment frame in each tag, but only one with the same language and
   content descriptor.

     <Header for 'Comment', ID: "COMM">
     Text encoding          $xx
     Language               $xx xx xx
     Short content descrip. <text string according to encoding> $00 (00)
     The actual text        <full text string according to encoding>
*/

class COMMFrame extends ID3V2Frame<Comment> {
  @override
  Comment decodeBody(List<int> data, Encoding enc) {
    final lang = enc.decode(data.sublist(0, 3));
    final splitIndex = data.indexOf(0x00);
    final description = enc.decode(data.sublist(3, splitIndex));
    final body = enc.decode(data.sublist(splitIndex + 1));

    return Comment(lang, description, body);
  }

  @override
  List<int> encode(Comment value, [String key]) {
    final enc = header?.encoding ?? utf8;

    return [
      ...enc.encode(frameTag),
      ...frameSizeInBytes(value.lang.length +
          value.description.length +
          1 +
          value.comment.length +
          1),
      ...separatorBytes,
      ...enc.encode(value.lang),
      ...enc.encode(value.description),
      0x00,
      ...enc.encode(value.comment)
    ];
  }

  @override
  String get frameTag => 'COMM';
}
