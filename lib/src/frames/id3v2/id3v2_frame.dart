import 'dart:convert';

import 'package:collection/collection.dart' as collection;

import '../../convert/hex_encoding.dart';
import '../../convert/utf16.dart';
import '../../frames/frame.dart';
import '../../model/consts.dart' as consts;
import '../../model/consts.dart';
import '../../tag_processor.dart';

class ID3V2ParsingException extends ParsingException {
  static const fram = '';

  ID3V2ParsingException(String cause) : super(cause);
}

abstract class ID3V2Frame<T> implements Frame<T> {
  // actually 2.2 not supported yet. it should be supported wia mixins
  static const headerLength = 10;

  final separatorBytes = [0x00, 0x00, 0x03];

  String get frameTag;

  final int _version;

  ID3V2FrameHeader _header;
  ID3V2FrameHeader get header => _header;

  ID3V2Frame(this._version);

  @override
  MapEntry<String, T> decode(List<int> data) {
    final tag = latin1.decode(data.sublist(0, 4));
    if (!consts.framesHeaders.keys.contains(tag)) {
      return null;
    }
    final size = _version >= 4
        ? sizeOfSyncSafe(data.sublist(4, 8))
        : sizeOf(data.sublist(4, 8));
    if (size <= 0) {
      return null;
    }
    final encoding = getEncoding(data[headerLength]);

    _header = ID3V2FrameHeader(tag, size, encoding: encoding);

    if (data.length < headerLength + _header?.length) {
      _header =
          ID3V2FrameHeader(tag, data.length - headerLength, encoding: encoding);
    }

    final body = data.sublist(headerLength + 1, headerLength + _header?.length);

    return MapEntry<String, T>(
        getTagPseudonym(_header.tag), decodeBody(body, encoding));
  }

  T decodeBody(List<int> data, Encoding enc);

  @override
  List<int> encode(T value, [String key]);

  /// Returns size of frame in bytes
  List<int> frameSizeInBytes(int value) {
    assert(value <= 16777216);

    final block = List<int>(4);
    final sevenBitMask = 0x7f;

    block[0] = (value >> 21) & sevenBitMask;
    block[1] = (value >> 14) & sevenBitMask;
    block[2] = (value >> 7) & sevenBitMask;
    block[3] = (value >> 0) & sevenBitMask;

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

  ///  Frame lenght represents as sync safe 32bit int
  int sizeOf(List<int> block) {
    assert(block.length == 4);

    var len = block[0] << 24;
    len += block[1] << 16;
    len += block[2] << 8;
    len += block[3];

    return len;
  }

  ///  Frame lenght represents as sync safe 32bit int
  int sizeOfSyncSafe(List<int> block) {
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
      case consts.EncodingBytes.utf16:
        return UTF16LE();
      case consts.EncodingBytes.utf16be:
        return UTF16BE();
      default:
        return HEXEncoding();
    }
  }

  int indexOfSplitPattern(List<int> list, List<int> pattern,
      [int initialOffset = 0]) {
    for (var i = initialOffset ?? 0;
        i < list.length - pattern.length;
        i += pattern.length) {
      final l = list.sublist(i, i + pattern.length);
      if (collection.ListEquality().equals(l, pattern)) {
        return i;
      }
    }
    return -1;
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
  int length;

  Encoding encoding;

  // todo: implement futher
  int flags;

  ID3V2FrameHeader(this.tag, this.length, {this.flags, this.encoding}) {
    assert(consts.framesHeaders.keys.contains(tag));
    assert(length > 0);
  }
}
