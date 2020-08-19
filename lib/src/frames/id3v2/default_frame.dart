import 'dart:convert';

import '../../frames/id3v2/id3v2_frame.dart';

class DefaultFrame extends ID3V2Frame<String> {
  final String _tag;

  DefaultFrame(this._tag, {int version = 4}) : super(version);

  @override
  String decodeBody(List<int> data, Encoding enc) {
    return enc.decode(data);
  }

  @override
  List<int> encode(String value, [String key]) {
    final tag = getTagByPseudonym(frameTag);

    final vBytes = utf8.encode(value);

    return [
      ...utf8.encode(tag),
      ...frameSizeInBytes(vBytes.length + 1),
      ...separatorBytes,
      ...vBytes
    ];
  }

  @override
  String get frameTag => _tag;
}
