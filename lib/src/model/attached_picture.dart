// ignore_for_file: unnecessary_overrides

import 'dart:convert';

import 'key_entity.dart';

/// Class describes attached picture from ID3 v2.x tags
class AttachedPicture implements KeyEntity<String> {
  static final _picturesType = const [
    'Other',
    '32x32 pixels "file icon" (PNG only)',
    'Other file icon',
    'Cover (front)',
    'Cover (back)',
    'Leaflet page',
    'Media (e.g. lable side of CD)',
    'Lead artist/lead performer/soloist',
    'Artist/performer',
    'Conductor',
    'Band/Orchestra',
    'Composer',
    'Lyricist/text writer',
    'Recording Location',
    'During recording',
    'During performance',
    'Movie/video screen capture',
    'A bright coloured fish',
    'Illustration',
    'Band/artist logotype',
    'Publisher/Studio logotype',
  ];

  /// The byte array of image data
  final List<int> imageData;

  /// Returns image data as BASE64 string
  String get imageData64 => base64.encode(imageData);

  // /// Write image data from BASE64 string
  // set imageData64(String imageDataString) =>
  //     imageData = base64.decode(imageDataString);

  /// The description for artwork ussualy filename
  final String description;

  /// The image type represents as byte.
  final int imageTypeCode;

  /// MIME type of image
  final String mime;

  /// Returns [String] representation of image type.
  ///
  /// eg. 'Band/Orchestra' or 'Cover (front)' etc...
  String get imageType => _picturesType[imageTypeCode];

  AttachedPicture(
      this.mime, this.imageTypeCode, this.description, this.imageData);

  AttachedPicture.base64(
      this.mime, this.imageTypeCode, this.description, String base64Image)
      : imageData = base64.decode(base64Image);

  @override
  String toString() =>
      '{mime:$mime, description:$description, bitmap: ${imageData64.substring(0, 32)}...}';

  @override
  int get hashCode => super.hashCode;

  @override
  bool operator ==(other) {
    if (other is! AttachedPicture) {
      return false;
    }
    if (imageTypeCode != other.imageTypeCode) {
      return false;
    }
    if (mime != other.mime) {
      return false;
    }
    if (description != other.description) {
      return false;
    }
    if (imageData.length != other.imageData.length) {
      return false;
    }
    for (var i = 0; i < imageData.length; i++) {
      if (imageData[i] != other.imageData[i]) {
        return false;
      }
    }
    return true;
  }

  @override
  String get key => imageType;
}
