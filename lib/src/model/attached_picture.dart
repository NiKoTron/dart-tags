class AttachedPicture {
  static final _picturesType = [
    "Other",
    "32x32 pixels 'file icon' (PNG only)",
    "Other file icon",
    "Cover (front)",
    "Cover (back)",
    "Leaflet page",
    "Media (e.g. lable side of CD)",
    "Lead artist/lead performer/soloist",
    "Artist/performer",
    "Conductor",
    "Band/Orchestra",
    "Composer",
    "Lyricist/text writer",
    "Recording Location",
    "During recording",
    "During performance",
    "Movie/video screen capture",
    "A bright coloured fish",
    "Illustration",
    "Band/artist logotype",
    "Publisher/Studio logotype",
  ];

  List<int> imageData;
  String description;
  int imageType;
  String mime;

  @override
  String toString() {
    return "AttachedPicture[($mime) $description, bytes[0..${imageData.length}]]";
  }
}
