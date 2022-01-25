import 'dart:convert';

import 'package:dart_tags/src/convert/utf16.dart';
import 'package:dart_tags/src/utils/image_extractor.dart';

import '../../frames/id3v2/id3v2_frame.dart';
import '../../model/attached_picture.dart';

/* http://id3.org/id3v2.4.0-frames
4.14.   Attached picture

   This frame contains a picture directly related to the audio file.
   Image format is the MIME type and subtype [MIME] for the image. In
   the event that the MIME media type name is omitted, "image/" will be
   implied. The "image/png" [PNG] or "image/jpeg" [JFIF] picture format
   should be used when interoperability is wanted. Description is a
   short description of the picture, represented as a terminated
   text string. There may be several pictures attached to one file, each
   in their individual "APIC" frame, but only one with the same content
   descriptor. There may only be one picture with the picture type
   declared as picture type $01 and $02 respectively. There is the
   possibility to put only a link to the image file by using the 'MIME
   type' "-->" and having a complete URL [URL] instead of picture data.
   The use of linked files should however be used sparingly since there
   is the risk of separation of files.

     <Header for 'Attached picture', ID: "APIC">
     Text encoding      $xx
     MIME type          <text string> $00
     Picture type       $xx
     Description        <text string according to encoding> $00 (00)
     Picture data       <binary data>


   Picture type:  $00  Other
                  $01  32x32 pixels 'file icon' (PNG only)
                  $02  Other file icon
                  $03  Cover (front)
                  $04  Cover (back)
                  $05  Leaflet page
                  $06  Media (e.g. label side of CD)
                  $07  Lead artist/lead performer/soloist
                  $08  Artist/performer
                  $09  Conductor
                  $0A  Band/Orchestra
                  $0B  Composer
                  $0C  Lyricist/text writer
                  $0D  Recording Location
                  $0E  During recording
                  $0F  During performance
                  $10  Movie/video screen capture
                  $11  A bright coloured fish
                  $12  Illustration
                  $13  Band/artist logotype
                  $14  Publisher/Studio logotype
*/

class ApicFrame extends ID3V2Frame<AttachedPicture> {
  final _imageExtractors = {
    'image/jpg': () => JPEGImageExtractor(),
    'image/jpeg': () => JPEGImageExtractor(),
    'image/png': () => PNGImageExtractor(),
  };

  ApicFrame({int version = 4}) : super(version);

  @override
  AttachedPicture decodeBody(List<int> data, Encoding enc) {
    final endOfMimeType = data.indexOf(0x00);

    final mime = latin1.decode(data.sublist(0, endOfMimeType));
    final imageType = data[endOfMimeType + 1];

    final startOfDescription = endOfMimeType + 2;
    final endOfDescription = indexOfSplitPattern(
        data, enc is UTF16 ? [0x00, 0x00] : [0x00], startOfDescription);

    final description =
        enc.decode(data.sublist(startOfDescription, endOfDescription));

    final startOfImageData = endOfDescription + (enc is UTF16 ? 2 : 1);

    final imageData = data.sublist(startOfImageData);

    final extractedImageData = _imageExtractors.containsKey(mime)
        ? _imageExtractors[mime]!().parse(imageData)
        : imageData;

    return AttachedPicture(mime, imageType, description, extractedImageData);
  }

  @override
  List<int> encode(AttachedPicture value, [String? key]) {
    final mimeEncoded = latin1.encode(value.mime);
    final descEncoded = utf8.encode(value.description);

    final b = [
      ...utf8.encode(frameTag),
      ...frameSizeInBytes(
          mimeEncoded.length + descEncoded.length + value.imageData.length + 4),
      ...separatorBytes,
      ...mimeEncoded,
      0x00,
      value.imageTypeCode,
      ...descEncoded,
      0x00,
      ...value.imageData
    ];
    return b;
  }

  @override
  String get frameTag => 'APIC';
}
