import 'dart:convert';

/// Class describes attached picture from ID3 v2.x tags
class AttachedPicture {
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
  List<int> imageData;

  /// Returns image data as BASE64 string
  String get imageData64 => base64.encode(imageData);

  /// Write image data from BASE64 string
  set imageData64(String imageDataString) =>
      imageData = base64.decode(imageDataString);

  /// The description for artwork ussualy filename
  String description;

  /// The image type represents as byte.
  int imageTypeCode;

  /// MIME type of image
  String mime;

  /// Returns [String] representation of image type.
  ///
  /// eg. 'Band/Orchestra' or 'Cover (front)' etc...
  String get imageType {
    return _picturesType[imageTypeCode];
  }

  @override
  String toString() {
    return '{mime:$mime, description:$description, bitmap: ${imageData64}}';
  }

  @override
  int get hashCode => super.hashCode;

  @override
  bool operator ==(other) {
    if (imageTypeCode != other.imageTypeCode) {
      return false;
    }
    if (mime != other.mime) {
      return false;
    }
    if (description != other.description) {
      return false;
    }
    if (imageData == null && other.imageData == null) {
      return true;
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
}
