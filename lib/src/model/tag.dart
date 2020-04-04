/// Class describes tag
class Tag {
  /// Type of tag. At this time supports 'id3'
  String type;

  /// Version of tag. eg. '2.4.0' or '1.1'
  String version;

  /// The map of tags. Values are dynamic because it can be not only String.
  Map<String, dynamic> tags;

  @override
  bool operator ==(other) {
    if (type != other.type) {
      return false;
    }
    if (version != other.version) {
      return false;
    }
    if (tags.length != other.tags.length) {
      return false;
    }
    return tags.keys.every(
        (key) => other.tags.containsKey(key) && tags[key] == other.tags[key]);
  }

  @override
  int get hashCode => super.hashCode;

  @override
  String toString() {
    return '{tag: $type, version: v$version tags:$tags}';
  }
}
