class Book {
  String _title;
  String _author;
  String _imagePath;

  String get title => _title;
  String get author => _author;
  String get imagePath => _imagePath;

  Book(this._title, this._author, this._imagePath);
}