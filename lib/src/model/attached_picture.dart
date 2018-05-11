/// Class describes attached picture from ID3 v2.x tags
class AttachedPicture {
  static final _picturesType = [
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
    return 'AttachedPicture[($mime) $description, bytes[0..${imageData.length}]]';
  }
}
