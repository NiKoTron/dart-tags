/// Class describes [Tag]
class Tag {
  
  /// Type of tag. At this time supports 'id3'
  String type;

  /// Version of tag. eg. '2.4.0' or '1.1'
  String version;

  /// The map of tags. Values are [dynamic] because it can be not only String.
  Map<String, dynamic> tags;

  @override
  String toString() {
    return "TAG: $type v$version\n$tags";
  }
}
