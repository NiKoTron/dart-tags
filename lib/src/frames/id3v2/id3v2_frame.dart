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
    final tag = latin1.decode(data.sublist(0, 4));
    if (!consts.framesHeaders.keys.contains(tag)) {
      //print('$tag unknown tag');
      return null;
    }
    final size = sizeOf(data.sublist(4, 8));
    if (size <= 0) {
      //print('frame size should be greater than zero');
      return null;
    }

    final encoding = getEncoding(data[headerLength]);
    _header = ID3V2FrameHeader(tag, encoding, size);

    //print('${data.length}, ${headerLength}, ${_header.length}');
    final body = data.sublist(headerLength + 1, headerLength + _header?.length);

    return MapEntry<String, T>(
        getTagPseudonym(_header.tag), decodeBody(body, encoding));
  }

  T decodeBody(List<int> data, Encoding enc);

  @override
  List<int> encode(T value, [String key]);

  List<int> frameSizeInBytes(int value) {
    final block = List<int>(4);
    final eightBitMask = 0xff;

    block[0] = (value >> 24) & eightBitMask;
    block[1] = (value >> 16) & eightBitMask;
    block[2] = (value >> 8) & eightBitMask;
    block[3] = (value >> 0) & eightBitMask;

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

    var len = block[0] << 24;
    len += block[1] << 16;
    len += block[2] << 8;
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

/* http://id3.org/id3v2.4.0-structure
4.   ID3v2 frame overview

   All ID3v2 frames consists of one frame header followed by one or more
   fields containing the actual information. The header is always 10
   bytes and laid out as follows:

     Frame ID      $xx xx xx xx  (four characters)
     Size      4 * %0xxxxxxx
     Flags         $xx xx

   The frame ID is made out of the characters capital A-Z and 0-9.
   Identifiers beginning with "X", "Y" and "Z" are for experimental
   frames and free for everyone to use, without the need to set the
   experimental bit in the tag header. Bear in mind that someone else
   might have used the same identifier as you. All other identifiers are
   either used or reserved for future use.

   The frame ID is followed by a size descriptor containing the size of
   the data in the final frame, after encryption, compression and
   unsynchronisation. The size is excluding the frame header ('total
   frame size' - 10 bytes) and stored as a 32 bit synchsafe integer.

   In the frame header the size descriptor is followed by two flag
   bytes. These flags are described in section 4.1.

   There is no fixed order of the frames' appearance in the tag,
   although it is desired that the frames are arranged in order of
   significance concerning the recognition of the file. An example of
   such order: UFID, TIT2, MCDI, TRCK ...

*/

class ID3V2FrameHeader {
  String tag;
  Encoding encoding;
  int length;

  // todo: implement futher
  int flags;

  ID3V2FrameHeader(this.tag, this.encoding, this.length, [this.flags]) {
    assert(consts.framesHeaders.keys.contains(this.tag));
    assert(this.encoding != null);
    assert(this.length > 0);
  }
}
