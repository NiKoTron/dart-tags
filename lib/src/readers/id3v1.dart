import 'dart:async';
import 'dart:convert';

import 'package:dart_tags/src/readers/reader.dart';

class ID3V1Reader extends Reader{
  ID3V1Reader() : super('ID3', '1.1');

  var _id3v1generes = [ "Blues","Classic Rock","Country","Dance","Disco","Funk","Grunge", "Hip-Hop","Jazz","Metal","New Age","Oldies","Other","Pop","R&B", "Rap","Reggae","Rock","Techno","Industrial","Alternative","Ska", "Death Metal","Pranks","Soundtrack","Euro-Techno","Ambient", "Trip-Hop","Vocal","Jazz+Funk","Fusion","Trance","Classical", "Instrumental","Acid","House","Game","Sound Clip","Gospel", "Noise","AlternRock","Bass","Soul","Punk","Space","Meditative", "Instrumental Pop","Instrumental Rock","Ethnic","Gothic", "Darkwave","Techno-Industrial","Electronic","Pop-Folk", "Eurodance","Dream","Southern Rock","Comedy","Cult","Gangsta", "Top 40","Christian Rap","Pop/Funk","Jungle","Native American", "Cabaret","New Wave","Psychadelic","Rave","Showtunes","Trailer", "Lo-Fi","Tribal","Acid Punk","Acid Jazz","Polka","Retro", "Musical","Rock & Roll","Hard Rock","Folk","Folk-Rock", "National Folk","Swing","Fast Fusion","Bebob","Latin","Revival", "Celtic","Bluegrass","Avantgarde","Gothic Rock","Progressive Rock", "Psychedelic Rock","Symphonic Rock","Slow Rock","Big Band", "Chorus","Easy Listening","Acoustic","Humour","Speech","Chanson", "Opera","Chamber Music","Sonata","Symphony","Booty Bass","Primus", "Porn Groove","Satire","Slow Jam","Club","Tango","Samba", "Folklore","Ballad","Power Ballad","Rhythmic Soul","Freestyle", "Duet","Punk Rock","Drum Solo","Acapella","Euro-House","Dance Hall" ];

  @override
  Future<Map<String, String>> parseValues(Future<List<int>> bytes) async {
    var sBytes = await bytes;
    assert(sBytes.length >= 128);

    sBytes = sBytes.sublist(sBytes.length-128);
    
    if(latin1.decode(sBytes.sublist(0,3)) == 'TAG'){
      var tagMap = new Map();  
      
      tagMap['title'] = latin1.decode(_clearZeros(sBytes.sublist(3,33)));
      tagMap['artist'] = latin1.decode(_clearZeros(sBytes.sublist(33,63)));
      tagMap['album'] = latin1.decode(_clearZeros(sBytes.sublist(63,93)));
      tagMap['year'] = latin1.decode(_clearZeros(sBytes.sublist(93,97)));

      var flag = sBytes[125];
      
      if(flag == 0){
        tagMap['comment'] = latin1.decode(_clearZeros(sBytes.sublist(97,125)));
        tagMap['track'] = sBytes[126].toString();
      } else {
        tagMap['comment'] = '';
        tagMap['track'] = '0';
      }
      var id = sBytes[127];
      tagMap['genre'] = id > 127 ? '' : _id3v1generes[id];
      
      return tagMap;
    }
    return null;
  }

  List<int> _clearZeros(List<int> zeros){
      return zeros.where((i) => i != 0).toList();
  }
}