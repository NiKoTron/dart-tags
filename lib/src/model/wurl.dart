import 'key_entity.dart';

/// Class describes url from WXXX tag
class WURL implements KeyEntity<String> {
  /// Description for url
  final String description;

  /// url
  final String url;

  WURL(this.description, this.url);

  @override
  String toString() {
    return '{description:$description, url: $url';
  }

  @override
  int get hashCode => super.hashCode;

  @override
  bool operator ==(other) {
    if (description != other.description) {
      return false;
    }
    if (url != other.url) {
      return false;
    }
    return true;
  }

  @override
  String get key => description;
}
