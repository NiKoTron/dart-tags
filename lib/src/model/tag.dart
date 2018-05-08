class Tag {
  String type;
  String version;
  Map<String, dynamic> tags;

  @override
  String toString() {
    return "TAG: $type v$version\n$tags";
  }
}
