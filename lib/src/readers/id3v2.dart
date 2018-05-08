import 'dart:async';
import 'dart:convert';

import 'package:dart_tags/src/readers/reader.dart';

class ID3V2Reader extends Reader {

  // v2.3+ frames  
  final _frames = {
    "AENC" : "Audio encryption",
    "APIC" : "Attached picture",
    "COMM" : "Comments",
    "COMR" : "Commercial frame",
    "ENCR" : "Encryption method registration",
    "EQUA" : "Equalization",
    "ETCO" : "Event timing codes",
    "GEOB" : "General encapsulated object",
    "GRID" : "Group identification registration",
    "IPLS" : "Involved people list",
    "LINK" : "Linked information",
    "MCDI" : "Music CD identifier",
    "MLLT" : "MPEG location lookup table",
    "OWNE" : "Ownership frame",
    "PRIV" : "Private frame",
    "PCNT" : "Play counter",
    "POPM" : "Popularimeter",
    "POSS" : "Position synchronisation frame",
    "RBUF" : "Recommended buffer size",
    "RVAD" : "Relative volume adjustment",
    "RVRB" : "Reverb",
    "SYLT" : "Synchronized lyric/text",
    "SYTC" : "Synchronized tempo codes",
    "TALB" : "Album/Movie/Show title",
    "TBPM" : "BPM (beats per minute)",
    "TCOM" : "Composer",
    "TCON" : "Content type",
    "TCOP" : "Copyright message",
    "TDAT" : "Date",
    "TDLY" : "Playlist delay",
    "TENC" : "Encoded by",
    "TEXT" : "Lyricist/Text writer",
    "TFLT" : "File type",
    "TIME" : "Time",
    "TIT1" : "Content group description",
    "TIT2" : "Title/songname/content description",
    "TIT3" : "Subtitle/Description refinement",
    "TKEY" : "Initial key",
    "TLAN" : "Language(s)",
    "TLEN" : "Length",
    "TMED" : "Media type",
    "TOAL" : "Original album/movie/show title",
    "TOFN" : "Original filename",
    "TOLY" : "Original lyricist(s)/text writer(s)",
    "TOPE" : "Original artist(s)/performer(s)",
    "TORY" : "Original release year",
    "TOWN" : "File owner/licensee",
    "TPE1" : "Lead performer(s)/Soloist(s)",
    "TPE2" : "Band/orchestra/accompaniment",
    "TPE3" : "Conductor/performer refinement",
    "TPE4" : "Interpreted, remixed, or otherwise modified by",
    "TPOS" : "Part of a set",
    "TPUB" : "Publisher",
    "TRCK" : "Track number/Position in set",
    "TRDA" : "Recording dates",
    "TRSN" : "Internet radio station name",
    "TRSO" : "Internet radio station owner",
    "TSIZ" : "Size",
    "TSRC" : "ISRC (international standard recording code)",
    "TSSE" : "Software/Hardware and settings used for encoding",
    "TYER" : "Year",
    "TXXX" : "User defined text information frame",
    "UFID" : "Unique file identifier",
    "USER" : "Terms of use",
    "USLT" : "Unsychronized lyric/text transcription",
    "WCOM" : "Commercial information",
    "WCOP" : "Copyright/Legal information",
    "WOAF" : "Official audio file webpage",
    "WOAR" : "Official artist/performer webpage",
    "WOAS" : "Official audio source webpage",
    "WORS" : "Official internet radio station homepage",
    "WPAY" : "Payment",
    "WPUB" : "Publishers official webpage",
    "WXXX" : "User defined URL link frame",
};
  
  
  final _frameShortcutsID3V2_3 = {
    "TIT2": "title",
    "TPE1": "artist",
    "TALB": "album",
    "TYER": "year",
    "COMM": "comment",
    "TRCK": "track",
    "TCON": "genre",
    "APIC": "picture",
    "USLT": "lyrics",
  };

//todo support v2.2
  final _frameShortcutsID3V2_2 = {
    "TT2": "title",
    "TP1": "artist",
    "TAL": "album",
    "TYE": "year",
    "COM": "comment",
    "TRK": "track",
    "TCO": "genre",
    "PIC": "picture",
    "ULT": "lyrics",
  };

  final _frameLegacy = {
      "BUF": "RBUF",
    "COM": "COMM",
    "CRA": "AENC",
    "EQU": "EQUA",
    "ETC": "ETCO",
    "GEO": "GEOB",
    "MCI": "MCDI",
    "MLL": "MLLT",
    "PIC": "APIC",
    "POP": "POPM",
    "REV": "RVRB",
    "RVA": "RVAD",
    "SLT": "SYLT",
    "STC": "SYTC",
    "TAL": "TALB",
    "TBP": "TBPM",
    "TCM": "TCOM",
    "TCO": "TCON",
    "TCR": "TCOP",
    "TDA": "TDAT",
    "TDY": "TDLY",
    "TEN": "TENC",
    "TFT": "TFLT",
    "TIM": "TIME",
    "TKE": "TKEY",
    "TLA": "TLAN",
    "TLE": "TLEN",
    "TMT": "TMED",
    "TOA": "TOPE",
    "TOF": "TOFN",
    "TOL": "TOLY",
    "TOR": "TORY",
    "TOT": "TOAL",
    "TP1": "TPE1",
    "TP2": "TPE2",
    "TP3": "TPE3",
    "TP4": "TPE4",
    "TPA": "TPOS",
    "TPB": "TPUB",
    "TRC": "TSRC",
    "TRD": "TRDA",
    "TRK": "TRCK",
    "TSI": "TSIZ",
    "TSS": "TSSE",
    "TT1": "TIT1",
    "TT2": "TIT2",
    "TT3": "TIT3",
    "TXT": "TEXT",
    "TXX": "TXXX",
    "TYE": "TYER",
    "UFI": "UFID",
    "ULT": "USLT",
    "WAF": "WOAF",
    "WAR": "WOAR",
    "WAS": "WOAS",
    "WCM": "WCOM",
    "WCP": "WCOP",
    "WPB": "WPB",
    "WXX": "WXXX",
  };

  int version_o1 = 2;
  int version_o2;
  int version_o3;

  final HEADER_LEN = 10;

  ID3V2Reader() : super('ID3', '2.');

  get version => '$version_o1.$version_o2.$version_o3';

  @override
  Future<Map<String, String>> parseValues(Future<List<int>> bytes) async {
    var sBytes = await bytes;
    assert(utf8.decode(sBytes.sublist(0, 3)) == 'ID3');

    Map<String, String> tags = {};

    version_o2 = sBytes[3];
    version_o3 = sBytes[4];

    var flag = sBytes[5];

    var size = sBytes[6] << 0x15;
    size += sBytes[7] << 14;
    size += sBytes[8] << 7;
    size += sBytes[9];

    var offset = 10;

    var end = true;

    while (end) {
      var tag = utf8.decode(sBytes.sublist(offset, offset + 4));
      var len = sBytes[offset + 7];
      
      print(tag);
      if (len > 0 && _isValidTag(tag)) {
        if (tag == 'APIC') {
          tags[tag] = "picture";
        }
        else {
          tags[_getTag(tag)] = utf8.decode(sBytes.sublist(
            offset + HEADER_LEN + 1, offset + HEADER_LEN + len - 1));
        }
      }
      offset = offset + HEADER_LEN + len;
      end = offset < size;
    }

    return tags;
  }

  String _getTag(String tag) {
    return _frameShortcutsID3V2_3.containsKey(tag)
        ? _frameShortcutsID3V2_3[tag]
        : tag;
  }

  bool _isValidTag(String tag){
    return _frames.containsKey(tag);
  }
}
