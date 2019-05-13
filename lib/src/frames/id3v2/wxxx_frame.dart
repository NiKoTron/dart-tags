import 'dart:convert';

import 'id3v2_frame.dart';

class WXXXFrame with ID3V2Frame<String> {
  @override
  List<int> encode(String value, [String key]) {
    final vBytes = [
      ...utf8.encode('$key${utf8.decode([0x00])}'),
      ...latin1.encode(value)
    ];
    return [
      ...utf8.encode(frameTag),
      ...frameSizeInBytes(vBytes.length + 1),
      ...separatorBytes,
      ...vBytes
    ];
  }

  @override
  String decodeBody(List<int> data, Encoding enc) {
    return enc.decode(data);
  }

  @override
  String get frameTag => 'WXXX';

  @override
  MapEntry<String, String> decode(List<int> data) {
    final encoding = ID3V2Frame.getEncoding(data[ID3V2Frame.headerLength]);
    final tag = encoding.decode(data.sublist(0, 4));

    assert(tag == frameTag);

    final len = sizeOf(data.sublist(4, 8));

    final body = data.sublist(
        ID3V2Frame.headerLength + 1, ID3V2Frame.headerLength + len);

    final splitIndex = body.indexOf(0);

    return MapEntry<String, String>(
        frameTag, decodeBody(data.sublist(splitIndex + 1), latin1));
  }
}
