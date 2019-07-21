import 'dart:convert';

import 'package:dart_tags/src/frames/id3v2/id3v2_frame.dart';

class DefaultFrame with ID3V2Frame<String> {
  final String _tag;

  DefaultFrame(this._tag);

  @override
  String decodeBody(List<int> data, Encoding enc) {
    return enc.decode(clearFrameData(data));
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
