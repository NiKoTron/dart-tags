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
    tag.tags.forEach((k, v) => tagsF.addAll(framer(k, v)));
    final s = _frameSizeInBytes(tagsF.length);

    final b = List<int>()
      ..addAll(utf8.encode('ID3'))
      ..add(0x04)
      ..add(0x00)
      ..add(0x00)
      ..addAll(s)
      ..addAll(tagsF);

    final c = Completer<List<int>>.sync()..complete(b);

    return c.future;
  }

  List<int> framer(String key, value) {
    final frame = List<int>();
    if (value is String) {
      final frameHeader =
          consts.frameHeaderShortcutsID3V2_3_Rev.containsKey(key)
              ? consts.frameHeaderShortcutsID3V2_3_Rev[key]
              : consts.framesHeaders.containsKey(key) ? key : 'TXXX';

      final kByte = utf8.encode(frameHeader);

      final vBytes = frameHeader == 'TXXX'
          ? utf8.encode('$key${utf8.decode([0x00])}$value')
          : utf8.encode(value);

      final fSize = _frameSizeInBytes(vBytes.length + 1);

      frame
        ..addAll(kByte)
        ..addAll(fSize)
        ..addAll([0x00, 0x00, 0x03])
        ..addAll(vBytes);
    } else if (value is AttachedPicture) {
      assert(key == 'APIC');
      final kByte = utf8.encode(key);

      final mimeEncoded = utf8.encode(value.mime);
      final descEncoded = utf8.encode(value.description);

      final fSize = _frameSizeInBytes(
          mimeEncoded.length + descEncoded.length + value.imageData.length + 4);

      frame
        ..addAll(kByte)
        ..addAll(fSize)
        ..addAll([0x00, 0x00, 0x03])
        ..addAll(mimeEncoded)
        ..addAll([0x00, value.imageTypeCode])
        ..addAll(descEncoded)
        ..add(0x00)
        ..addAll(value.imageData);
    }
    return frame;
  }

  static List<int> _frameSizeInBytes(int value) {
    assert(value <= 9999);

    final block = List<int>(4);

    block[0] = ((value & 0xFF000000) >> 21);
    block[1] = ((value & 0x00FF0000) >> 14);
    block[2] = ((value & 0x0000FF00) >> 7);
    block[3] = ((value & 0x000000FF) >> 0);

    return block;
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
    return List<int>.from(tags)..addAll(source);
  }
}
