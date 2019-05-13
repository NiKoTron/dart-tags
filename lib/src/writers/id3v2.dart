import 'dart:async';
import 'dart:convert';

import 'package:dart_tags/src/model/attached_picture.dart';
import 'package:dart_tags/src/model/consts.dart' as consts;
import 'package:dart_tags/src/model/tag.dart';
import 'package:dart_tags/src/writers/writer.dart';

class ID3V2Writer extends Writer {
  ID3V2Writer() : super('ID3', '2.4');

  @override
  Future<List<int>> prepareTag(Tag tag) {
    final tagsF = List<int>();
    tag.tags.forEach((k, v) => tagsF.addAll(_framer(k, v)));

    final c = Completer<List<int>>.sync()
      ..complete([
        ...utf8.encode('ID3'),
        ...[0x04, 0x00, 0x00],
        ...frameSizeInBytes(tagsF.length),
        ...tagsF
      ]);

    return c.future;
  }

  List<int> _framer(String key, value) {
    final separatorBytes = [0x00, 0x00, 0x03];
    if (value is String) {
      final frameHeader =
          consts.frameHeaderShortcutsID3V2_3_Rev.containsKey(key)
              ? consts.frameHeaderShortcutsID3V2_3_Rev[key]
              : consts.framesHeaders.containsKey(key) ? key : 'TXXX';

      final vBytes = frameHeader == 'TXXX'
          ? utf8.encode('$key${utf8.decode([0x00])}$value')
          : utf8.encode(value);

      return [
        ...utf8.encode(frameHeader),
        ...frameSizeInBytes(vBytes.length + 1),
        ...separatorBytes,
        ...vBytes
      ];
    } else if (value is AttachedPicture) {
      assert(key == 'APIC');

      final mimeEncoded = utf8.encode(value.mime);
      final descEncoded = utf8.encode(value.description);

      return [
        ...utf8.encode(key),
        ...frameSizeInBytes(mimeEncoded.length +
            descEncoded.length +
            value.imageData.length +
            4),
        ...separatorBytes,
        ...mimeEncoded,
        0x00,
        value.imageTypeCode,
        ...descEncoded,
        0x00,
        ...value.imageData
      ];
    }
    return [];
  }

  static List<int> frameSizeInBytes(int value) {
    return [
      ((value & 0xFF000000) >> 21),
      ((value & 0x00FF0000) >> 14),
      ((value & 0x0000FF00) >> 7),
      ((value & 0x000000FF) >> 0)
    ];
  }

  @override
  Future<List<int>> removeExistingTag(List<int> bytes) {
    final c = Completer<List<int>>.sync();

    Utf8Codec(allowMalformed: true).decode(bytes.sublist(0, 3)) != 'ID3'
        ? c.complete(bytes)
        : c.complete(bytes.sublist(_sizeOf(bytes.sublist(6, 10))));

    return c.future;
  }

  int _sizeOf(List<int> block) {
    assert(block.length == 4);

    var len = block[0] << 21;
    len += block[1] << 14;
    len += block[2] << 7;
    len += block[3];

    return len;
  }

  @override
  List<int> combine(List<int> source, List<int> tags) {
    return [...tags, ...source];
  }
}
