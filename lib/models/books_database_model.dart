import 'package:digital_local_library/data/book.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BooksDatabaseModel extends Model {
  Stream<QuerySnapshot> _stream;

  List<Book> _books = [];

  List<Book> get books => _books;

  BooksDatabaseModel() {
    _stream = Firestore.instance.collection("books").snapshots();
    _stream.listen((querySnapshot) {
      _books = querySnapshot.documents
          .map((dSnap) {
            // Description is an optional property
            String bookDescription =
                dSnap.data.containsKey('description') ? dSnap.data['description'] : "";
            return new Book(
                isbn: dSnap.data['isbn'].toString(),
                title: dSnap.data['title'].toString(),
                author: dSnap.data['author'].toString(),
                imagePath: dSnap.data['imagePath'].toString(),
                description: bookDescription,
                uid: dSnap.data['uid'].toString());
          })
          .toList()
          .reversed
          .toList();
    });
  }

  void updateBooks() {
    notifyListeners();
  }

  Future<bool> uploadBook({@required Book book}) async {
    try {
      await Firestore.instance.collection("books").document(book.isbn).setData({
        'author': book.author,
        'title': book.title,
        'isbn': book.isbn,
        'imagePath': book.imagePath,
        'description': book.description,
        'uid': book.uid,
      });
    } catch (e) {
      return false;
    }
    return true;
  }
}
