import 'package:digital_local_libary/book.dart';
import 'package:scoped_model/scoped_model.dart';

class BooksModel extends Model {
  List<Book> _books;
  List<Book> _filteredBooks;

  BooksModel() {
    _books = [
      Book("Das Cafe am Rande der Welt", "John Strelecky",
          "assets/testData/cafe-am-rande.jpg")];
    _filteredBooks = _books;
  }

  List<Book> get books => _filteredBooks;

  void changeBooks(List<Book> books) {
    this._books = books;
    notifyListeners();
  }

  void updateBooks() {
    _books.add(Book("Kaffee und Zigaretten", "Ferdinand von Schirach",
        "assets/testData/kaffee.jpg"));
    notifyListeners();
  }

  void applyFilter(){
    
  }
}
