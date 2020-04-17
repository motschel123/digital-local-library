import 'package:digital_local_library/data/book.dart';
import 'package:digital_local_library/firebase_interfaces/books.dart';
import 'package:scoped_model/scoped_model.dart';

class BooksDatabaseModel extends Model {
  BooksInterface _booksInterface = BooksInterface();

  List<Book> _books = [];
  List<Book> get books => _books;

  BooksDatabaseModel(){
    updateBooks();
  }

  Future<void> updateBooks() async {
    return _booksInterface.booksSnapshot.then((querySnap) {
      _books = querySnap.documents
          .map((dSnap) {
            return Book.fromMap(dSnap.data);
          })
          .toList()
          .reversed
          .toList();
          return;
    }).then<void>((_) {
      notifyListeners();
      return;
    });
  }

  Future<void> uploadBook(Book book) async {
    return _booksInterface.uploadBook(book);
  }
}
