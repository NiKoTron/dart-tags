import 'dart:convert';

import 'package:dart_tags/src/frames/id3v2/id3v2_frame.dart';
import 'package:dart_tags/src/model/consts.dart' as consts;

class DefaultFrame with ID3V2Frame<String> {
  String _tag;

  DefaultFrame(this._tag);

  @override
  String decodeBody(List<int> data, Encoding enc) {
    return enc.decode(clearFrameData(data));
  }

  @override
  List<int> encode(String value) {
    final frameHeader = consts.frameHeaderShortcutsID3V2_3_Rev.containsKey(_tag)
        ? consts.frameHeaderShortcutsID3V2_3_Rev[_tag]
        : _tag;

    final vBytes = utf8.encode(value);

    return [
      ...utf8.encode(frameHeader),
      ...frameSizeInBytes(vBytes.length + 1),
      ...separatorBytes,
      ...vBytes
    ];
  }

  @override
  String tagFrame() {
    return _tag;
  }
}
