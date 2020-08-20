import 'dart:convert';

import 'package:dart_tags/src/frames/id3v2/apic_frame.dart';
import 'package:dart_tags/src/frames/id3v2/comm_frame.dart';
import 'package:dart_tags/src/frames/id3v2/txxx_frame.dart';
import 'package:dart_tags/src/frames/id3v2/uslt_frame.dart';
import 'package:dart_tags/src/frames/id3v2/wxxx_frame.dart';
import 'package:dart_tags/src/model/consts.dart' as consts;

import 'id3v2/default_frame.dart';

/// Abstract implementation of id3v2 frame
abstract class Frame<T> {
  /// Encode [key] tag with [value] to bytearray
  List<int> encode(T value, [String key]);

  /// Decode byte [data] to frame data map
  MapEntry<String, T> decode(List<int> data);
}

class FrameFactory<T extends Frame> {
  String version;

  // ignore: avoid_annotating_with_dynamic
  Frame Function(dynamic entry) _frameGetter;

  Frame defaultFrame;

  FrameFactory._internal(this.version, this._frameGetter, [this.defaultFrame]);

  factory FrameFactory(String tagType, String tagVersion) {
    if (tagType == 'ID3') {
      if (tagVersion.startsWith('2.3.')) {
        return FrameFactory._internal(tagVersion, FramesID3V23().getFrame);
      }
      if (tagVersion.startsWith('2.4.')) {
        return FrameFactory._internal(tagVersion, FramesID3V24().getFrame);
      }
    }
    return FrameFactory._internal('0', (v) => null);
  }

  T getFrame(entry) => _frameGetter(entry);
}

class FramesID3V23 extends FramesID3V24 {
  @override
  Map<String, Frame> get _frames => {
        'APIC': ApicFrame(version: 3),
        'TXXX': TXXXFrame(version: 3),
        'WXXX': WXXXFrame(version: 3),
        'COMM': COMMFrame(version: 3),
        'USLT': USLTFrame(version: 3),
      };

  @override
  Frame<T> _getFrame<T>(String tag) {
    return _frames[tag] ?? DefaultFrame(tag, version: 3);
  }
}

class FramesID3V24 {
  Map<String, Frame> get _frames => {
        'APIC': ApicFrame(),
        'TXXX': TXXXFrame(),
        'WXXX': WXXXFrame(),
        'COMM': COMMFrame(),
        'USLT': USLTFrame(),
      };

  Frame<T> _getFrame<T>(String tag) {
    return _frames[tag] ?? DefaultFrame(tag);
  }

  String getTagByPseudonym(String tag) {
    return consts.frameHeaderShortcutsID3V2_3_Rev.containsKey(tag)
        ? consts.frameHeaderShortcutsID3V2_3_Rev[tag]
        : consts.framesHeaders.containsKey(tag) ? tag : 'TXXX';
  }

  Frame<T> getFrame<T>(data) {
    assert(data is List<int> || data is String);

    if (data is List<int>) {
      final tag = latin1.decode(data.sublist(0, 4));
      return _getFrame(consts.framesV23_V24[tag] ?? tag);
    } else if (data is String) {
      return _getFrame(getTagByPseudonym(data));
    }
    return null;
  }
}
