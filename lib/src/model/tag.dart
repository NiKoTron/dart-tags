class Tag {
  String type;
  String version;
  Map<String, String> tags;

  @override
  String toString() {
    return "TAG: $type v$version\n$tags";
  }
}
