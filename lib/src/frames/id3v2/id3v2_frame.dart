import 'dart:convert';

import 'package:dart_tags/src/convert/utf16.dart';
import 'package:dart_tags/src/frames/frame.dart';
import 'package:dart_tags/src/model/consts.dart' as consts;
import 'package:dart_tags/src/model/consts.dart';

abstract class ID3V2Frame<T> implements Frame<T> {
  // actually 2.2 not supported yet. it should be supported wia mixins
  static const headerLength = 10;

  final separatorBytes = [0x00, 0x00, 0x03];

  String get frameTag;

  ID3V2FrameHeader _header;
  ID3V2FrameHeader get header => _header;

  List<int> clearFrameData(List<int> bytes) {
    if (bytes.length > 3 && bytes[0] == 0xFF && bytes[1] == 0xFE) {
      bytes = bytes.sublist(2);
    }
    return bytes.where((i) => i != 0).toList();
  }

  @override
  MapEntry<String, T> decode(List<int> data) {
    final encoding = getEncoding(data[headerLength]);

    _header = ID3V2FrameHeader(encoding.decode(data.sublist(0, 4)), encoding,
        sizeOf(data.sublist(4, 8)));

    final body = data.sublist(headerLength + 1, headerLength + header.length);

    return MapEntry<String, T>(
        getTagPseudonym(header.tag), decodeBody(body, encoding));
  }

  T decodeBody(List<int> data, Encoding enc);

  @override
  List<int> encode(T value, [String key]);

  List<int> frameSizeInBytes(int value) {
    final block = List<int>(4);

    block[0] = ((value & 0xFF000000) >> 21);
    block[1] = ((value & 0x00FF0000) >> 14);
    block[2] = ((value & 0x0000FF00) >> 7);
    block[3] = ((value & 0x000000FF) >> 0);

    return block;
  }

  String getTagByPseudonym(String tag) {
    return consts.frameHeaderShortcutsID3V2_3_Rev.containsKey(tag)
        ? consts.frameHeaderShortcutsID3V2_3_Rev[tag]
        : tag;
  }

  String getTagPseudonym(String tag) {
    return consts.frameHeaderShortcutsID3V2_3.containsKey(tag)
        ? consts.frameHeaderShortcutsID3V2_3[tag]
        : tag;
  }

  bool isTagValid(String tag) =>
      tag.isNotEmpty && consts.framesHeaders.containsKey(tag);

  int sizeOf(List<int> block) {
    assert(block.length == 4);

    var len = block[0] << 21;
    len += block[1] << 14;
    len += block[2] << 7;
    len += block[3];

    return len;
  }

  static Encoding getEncoding(int type) {
    switch (type) {
      case EncodingBytes.latin1:
        return latin1;
      case EncodingBytes.utf8:
        return Utf8Codec(allowMalformed: true);
      default:
        return UTF16();
    }
  }
}

/*
3.1.   ID3v2 header

   The first part of the ID3v2 tag is the 10 byte tag header, laid out
   as follows:

     ID3v2/file identifier      "ID3"
     ID3v2 version              $04 00
     ID3v2 flags                %abcd0000
     ID3v2 size             4 * %0xxxxxxx

   The first three bytes of the tag are always "ID3", to indicate that
   this is an ID3v2 tag, directly followed by the two version bytes. The
   first byte of ID3v2 version is its major version, while the second
   byte is its revision number. In this case this is ID3v2.4.0. All
   revisions are backwards compatible while major versions are not. If
   software with ID3v2.4.0 and below support should encounter version
   five or higher it should simply ignore the whole tag. Version or
   revision will never be $FF.

   The version is followed by the ID3v2 flags field, of which currently
   four flags are used.
  */

class ID3V2FrameHeader {
  String tag;
  Encoding encoding;
  int length;

  // todo: implement futher
  int flags;

  ID3V2FrameHeader(this.tag, this.encoding, this.length, [this.flags]);
}
