// ignore_for_file: unnecessary_overrides

import 'package:dart_tags/src/model/key_entity.dart';

/// Class describes unsynchronised lyrics entity from ID3 v2.x tags
class UnSyncLyric implements KeyEntity<String> {
  /// 3 character of language code e.g. "eng"
  final String lang;

  /// Description for lyrics
  final String description;

  /// Lyrics body
  final String lyrics;

  UnSyncLyric(this.lang, this.description, this.lyrics);

  @override
  String toString() {
    return '{language:$lang, description:$description, body: $lyrics';
  }

  @override
  int get hashCode => super.hashCode;

  @override
  bool operator ==(other) {
    if (other is! UnSyncLyric) {
      return false;
    }
    if (lang != other.lang) {
      return false;
    }
    if (description != other.description) {
      return false;
    }
    if (lyrics != other.lyrics) {
      return false;
    }
    return true;
  }

  @override
  String get key => '$lang:$description';
}
