import 'dart:convert';

import 'id3v2_frame.dart';

class TXXXFrame with ID3V2Frame<String> {
  @override
  List<int> encode(String value) {
    final vBytes = utf8.encode('$_tag${utf8.decode([0x00])}$value');
    return [
      ...utf8.encode(_tag),
      ...frameSizeInBytes(vBytes.length + 1),
      ...separatorBytes,
      ...vBytes
    ];
  }

  @override
  String decodeBody(List<int> data, Encoding enc) {
    return enc.decode(data);
  }

  String _tag = 'TXXX';

  @override
  String tagFrame() => _tag;

  @override
  MapEntry<String, String> decode(List<int> data) {
    final encoding = ID3V2Frame.getEncoding(data[ID3V2Frame.headerLength]);
    final tag = encoding.decode(data.sublist(0, 4));

    assert(tag == tagFrame());

    final len = sizeOf(data.sublist(4, 8));

    final body = data.sublist(
        ID3V2Frame.headerLength + 1, ID3V2Frame.headerLength + len);

    final splitIndex = body.indexOf(0);

    _tag =
        splitIndex == 0 ? 'TXXX' : encoding.decode(data.sublist(0, splitIndex));

    return MapEntry<String, String>(
        tagFrame(), decodeBody(data.sublist(splitIndex + 1), encoding));
  }
}
