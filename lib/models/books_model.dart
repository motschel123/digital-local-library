import 'package:digital_local_libary/book.dart';
import 'package:scoped_model/scoped_model.dart';

class BooksModel extends Model {
  List<Book> _books;
  
  List<Book> get books => _books;

  BooksModel() {
    _books = [
      Book("Das Cafe am Rande der Welt", "John Strelecky", "assets/testData/cafe-am-rande.jpg")];
  }

  

  void updateBooks() {
    this._books = [
      Book("Das Cafe am Rande der Welt", "John Strelecky", "assets/testData/cafe-am-rande.jpg"),
      Book("Kaffee und Zigaretten", "Ferdinand von Schirach", "assets/testData/kaffee.jpg")];
    notifyListeners();
  }
}
