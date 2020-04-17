import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_local_library/data/book.dart';

class BooksInterface {
  CollectionReference _bookCollection = Firestore.instance.collection('books');

  Future<QuerySnapshot> get booksSnapshot => _bookCollection.getDocuments();

  BooksInterface();

  Future<void> uploadBook(Book book) async {
    try {
      await _bookCollection.document(book.isbn).setData(book.toMap());
    } catch (e) {
      print(e.toString());
    }
  }
}
