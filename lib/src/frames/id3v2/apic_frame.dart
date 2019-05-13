import 'dart:convert';

import 'package:dart_tags/src/frames/id3v2/id3v2_frame.dart';
import 'package:dart_tags/src/model/attached_picture.dart';

class ApicFrame with ID3V2Frame<AttachedPicture> {
  @override
  AttachedPicture decodeBody(List<int> data, Encoding enc) {
    final iterator = data.iterator;
    var buff = <int>[];

    final attachedPicture = AttachedPicture();

    var cont = 0;

    while (iterator.moveNext() && cont < 4) {
      final crnt = iterator.current;
      if (crnt == 0x00 && cont < 3) {
        if (cont == 1 && buff.isNotEmpty) {
          attachedPicture.imageTypeCode = buff[0];
          cont++;
          attachedPicture.description = enc.decode(buff.sublist(1));
        } else {
          attachedPicture.mime = enc.decode(buff);
        }
        buff = [];
        cont++;
        continue;
      }
      buff.add(crnt);
    }

    attachedPicture.imageData = buff;

    return attachedPicture;
  }

  @override
  List<int> encode(AttachedPicture tag, [String key]) {
    final mimeEncoded = utf8.encode(tag.mime);
    final descEncoded = utf8.encode(tag.description);

    return [
      ...utf8.encode(frameTag),
      ...frameSizeInBytes(
          mimeEncoded.length + descEncoded.length + tag.imageData.length + 4),
      ...separatorBytes,
      ...mimeEncoded,
      tag.imageTypeCode,
      ...descEncoded,
      0x00,
      ...tag.imageData
    ];
  }

  @override
  String get frameTag => 'APIC';
}
