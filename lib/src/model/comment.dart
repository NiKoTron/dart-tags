enum Language {
  eng,
}

class Comment {
  final Language lang;
  final String description;
  final String comment;

  Comment(this.lang, this.description, this.comment);
}
