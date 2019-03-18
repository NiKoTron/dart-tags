import 'dart:async';
import 'dart:convert';

import 'package:dart_tags/src/model/attached_picture.dart';
import 'package:dart_tags/src/readers/reader.dart';

class ID3V2Reader extends Reader {
  // v2.3+ frames
  static final _frames = const <String, String>{
    'AENC': 'Audio encryption',
    'APIC': 'Attached picture',
    'COMM': 'Comments',
    'COMR': 'Commercial frame',
    'ENCR': 'Encryption method registration',
    'EQUA': 'Equalization',
    'ETCO': 'Event timing codes',
    'GEOB': 'General encapsulated object',
    'GRID': 'Group identification registration',
    'IPLS': 'Involved people list',
    'LINK': 'Linked information',
    'MCDI': 'Music CD identifier',
    'MLLT': 'MPEG location lookup table',
    'OWNE': 'Ownership frame',
    'PRIV': 'Private frame',
    'PCNT': 'Play counter',
    'POPM': 'Popularimeter',
    'POSS': 'Position synchronisation frame',
    'RBUF': 'Recommended buffer size',
    'RVAD': 'Relative volume adjustment',
    'RVRB': 'Reverb',
    'SYLT': 'Synchronized lyric/text',
    'SYTC': 'Synchronized tempo codes',
    'TALB': 'Album/Movie/Show title',
    'TBPM': 'BPM (beats per minute)',
    'TCOM': 'Composer',
    'TCON': 'Content type',
    'TCOP': 'Copyright message',
    'TDAT': 'Date',
    'TDLY': 'Playlist delay',
    'TENC': 'Encoded by',
    'TEXT': 'Lyricist/Text writer',
    'TFLT': 'File type',
    'TIME': 'Time',
    'TIT1': 'Content group description',
    'TIT2': 'Title/songname/content description',
    'TIT3': 'Subtitle/Description refinement',
    'TKEY': 'Initial key',
    'TLAN': 'Language(s)',
    'TLEN': 'Length',
    'TMED': 'Media type',
    'TOAL': 'Original album/movie/show title',
    'TOFN': 'Original filename',
    'TOLY': 'Original lyricist(s)/text writer(s)',
    'TOPE': 'Original artist(s)/performer(s)',
    'TORY': 'Original release year',
    'TOWN': 'File owner/licensee',
    'TPE1': 'Lead performer(s)/Soloist(s)',
    'TPE2': 'Band/orchestra/accompaniment',
    'TPE3': 'Conductor/performer refinement',
    'TPE4': 'Interpreted, remixed, or otherwise modified by',
    'TPOS': 'Part of a set',
    'TPUB': 'Publisher',
    'TRCK': 'Track number/Position in set',
    'TRDA': 'Recording dates',
    'TRSN': 'Internet radio station name',
    'TRSO': 'Internet radio station owner',
    'TSIZ': 'Size',
    'TSRC': 'ISRC (international standard recording code)',
    'TSSE': 'Software/Hardware and settings used for encoding',
    'TYER': 'Year',
    'TXXX': 'User defined text information frame',
    'UFID': 'Unique file identifier',
    'USER': 'Terms of use',
    'USLT': 'Unsychronized lyric/text transcription',
    'WCOM': 'Commercial information',
    'WCOP': 'Copyright/Legal information',
    'WOAF': 'Official audio file webpage',
    'WOAR': 'Official artist/performer webpage',
    'WOAS': 'Official audio source webpage',
    'WORS': 'Official internet radio station homepage',
    'WPAY': 'Payment',
    'WPUB': 'Publishers official webpage',
    'WXXX': 'User defined URL link frame',
  };

  static final _frameShortcutsID3V2_3 = const <String, String>{
    'TIT2': 'title',
    'TPE1': 'artist',
    'TALB': 'album',
    'TYER': 'year',
    'COMM': 'comment',
    'TRCK': 'track',
    'TCON': 'genre',
    'APIC': 'picture',
    'USLT': 'lyrics',
  };

  // todo support v2.2
  // ignore: unused_field
  static final _frameShortcutsID3V2_2 = const <String, String>{
    'TT2': 'title',
    'TP1': 'artist',
    'TAL': 'album',
    'TYE': 'year',
    'COM': 'comment',
    'TRK': 'track',
    'TCO': 'genre',
    'PIC': 'picture',
    'ULT': 'lyrics',
  };

  // todo support v2.2
  // ignore: unused_field
  static final _frameLegacy = const <String, String>{
    'BUF': 'RBUF',
    'COM': 'COMM',
    'CRA': 'AENC',
    'EQU': 'EQUA',
    'ETC': 'ETCO',
    'GEO': 'GEOB',
    'MCI': 'MCDI',
    'MLL': 'MLLT',
    'PIC': 'APIC',
    'POP': 'POPM',
    'REV': 'RVRB',
    'RVA': 'RVAD',
    'SLT': 'SYLT',
    'STC': 'SYTC',
    'TAL': 'TALB',
    'TBP': 'TBPM',
    'TCM': 'TCOM',
    'TCO': 'TCON',
    'TCR': 'TCOP',
    'TDA': 'TDAT',
    'TDY': 'TDLY',
    'TEN': 'TENC',
    'TFT': 'TFLT',
    'TIM': 'TIME',
    'TKE': 'TKEY',
    'TLA': 'TLAN',
    'TLE': 'TLEN',
    'TMT': 'TMED',
    'TOA': 'TOPE',
    'TOF': 'TOFN',
    'TOL': 'TOLY',
    'TOR': 'TORY',
    'TOT': 'TOAL',
    'TP1': 'TPE1',
    'TP2': 'TPE2',
    'TP3': 'TPE3',
    'TP4': 'TPE4',
    'TPA': 'TPOS',
    'TPB': 'TPUB',
    'TRC': 'TSRC',
    'TRD': 'TRDA',
    'TRK': 'TRCK',
    'TSI': 'TSIZ',
    'TSS': 'TSSE',
    'TT1': 'TIT1',
    'TT2': 'TIT2',
    'TT3': 'TIT3',
    'TXT': 'TEXT',
    'TXX': 'TXXX',
    'TYE': 'TYER',
    'UFI': 'UFID',
    'ULT': 'USLT',
    'WAF': 'WOAF',
    'WAR': 'WOAR',
    'WAS': 'WOAS',
    'WCM': 'WCOM',
    'WCP': 'WCOP',
    'WPB': 'WPB',
    'WXX': 'WXXX',
  };

  // [ISO-8859-1]. Terminated with $00.
  static const _latin1 = 0x00;

  // [UTF-16] encoded Unicode [UNICODE] with BOM. All strings in the same frame SHALL have the same byteorder. Terminated with $00 00. (use in future)
  // ignore: unused_field
  static const _utf16 = 0x01;

  // [UTF-16] encoded Unicode [UNICODE] without BOM. Terminated with $00 00. (use in future)
  // ignore: unused_field
  static const _utf16be = 0x02;

  // [UTF-8] encoded Unicode [UNICODE]. Terminated with $00.
  static const _utf8 = 0x03;

  int get _headerLength => version_o2 > 2 ? 10 : 6;

  int version_o1 = 2;
  int version_o2 = 0;
  int version_o3 = 0;

  ID3V2Reader() : super('ID3', '2.');

  @override
  String get version => '$version_o1.$version_o2.$version_o3';

  @override
  Future<Map<String, dynamic>> parseValues(Future<List<int>> bytes) async {
    final sBytes = await bytes;
    final tags = <String, dynamic>{};

    if (new Utf8Codec(allowMalformed: true).decode(sBytes.sublist(0, 3)) !=
        'ID3') {
      return tags;
    }

    version_o2 = sBytes[3];
    version_o3 = sBytes[4];

    final flags = sBytes[5];

    // ignore: unused_local_variable
    final unsync = flags & 0x80 != 0;
    // ignore: unused_local_variable
    final xheader = flags & 0x40 != 0;
    // ignore: unused_local_variable
    final experimental = flags & 0x20 != 0;

    final size = _sizeOf(sBytes.sublist(6, 10));

    var offset = 10;

    var end = true;

    while (end) {
      final encoding = _getEncoding(sBytes[offset + _headerLength]);
      final tag = encoding.decode(sBytes.sublist(offset, offset + 4));

      final len = _sizeOf(sBytes.sublist(offset + 4, offset + 8));

      if (len > 0 && _isValidTag(tag)) {
        switch (tag) {
          case 'APIC':
            tags[tag] = _parsePicture(
                sBytes.sublist(
                    offset + _headerLength + 1, offset + _headerLength + len),
                encoding);
            break;
          case 'TXXX':
            final frame = sBytes.sublist(
                offset + _headerLength + 1, offset + _headerLength + len);
            final splitIndex = frame.indexOf(0);
            tags[splitIndex == 0
                    ? tag
                    : encoding.decode(frame.sublist(0, splitIndex))] =
                encoding.decode(frame.sublist(splitIndex + 1));
            break;
          case 'WXXX':
            final frame = sBytes.sublist(
                offset + _headerLength + 1, offset + _headerLength + len);
            final splitIndex = frame.indexOf(0);
            tags[splitIndex == 0
                    ? tag
                    : encoding.decode(frame.sublist(0, splitIndex))] =
                latin1.decode(frame.sublist(splitIndex + 1));
            break;
          default:
            tags[_getTag(tag)] = encoding.decode(_clearFrameData(sBytes.sublist(
                offset + _headerLength + 1, offset + _headerLength + len)));
        }
      }

      offset = offset + _headerLength + len;
      end = offset < size;
    }

    return tags;
  }

  List<int> _clearFrameData(List<int> bytes) {
    if (bytes.length > 3 && bytes[0] == 0xFF && bytes[1] == 0xFE) {
      bytes = bytes.sublist(2);
    }
    return bytes.where((i) => i != 0).toList();
  }

  int _sizeOf(List<int> block) {
    assert(block.length == 4);

    var len = block[0] << 21;
    len += block[1] << 14;
    len += block[2] << 7;
    len += block[3];

    return len;
  }

  Encoding _getEncoding(int type) {
    switch (type) {
      case _latin1:
        return latin1;
      case _utf8:
        return new Utf8Codec(allowMalformed: true);
      default:
        return new UTF16();
    }
  }

  String _getTag(String tag) {
    return _frameShortcutsID3V2_3.containsKey(tag)
        ? _frameShortcutsID3V2_3[tag]
        : tag;
  }

  bool _isValidTag(String tag) {
    return _frames.containsKey(tag);
  }

  AttachedPicture _parsePicture(List<int> sublist, Encoding enc) {
    final iterator = sublist.iterator;
    var buff = <int>[];

    final attachedPicture = new AttachedPicture();

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
}

class UTF16 extends Encoding {
  @override
  Converter<List<int>, String> get decoder => new _UTF16Decoder();

  @override
  Converter<String, List<int>> get encoder => new _UTF16Enoder();

  @override
  String get name => 'utf16';
}

class _UTF16Decoder extends Converter<List<int>, String> {
  @override
  String convert(List<int> input) {
    return new String.fromCharCodes(input);
  }
}

class _UTF16Enoder extends Converter<String, List<int>> {
  @override
  List<int> convert(String input) {
    return input.runes.toList();
  }
}
