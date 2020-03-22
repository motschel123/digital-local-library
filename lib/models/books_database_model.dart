import 'package:digital_local_library/data/book.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BooksDatabaseModel extends Model {
  final Stream<QuerySnapshot> _stream =
      Firestore.instance.collection("books").snapshots();

  List<Book> _books = [];

  List<Book> get books => _books;

  BooksDatabaseModel() {
    _stream.listen((querySnapshot) {
      _books = querySnapshot.documents
          .map((dSnap) {
            return new Book(
                isbn: dSnap.data['isbn'].toString(),
                title: dSnap.data['title'].toString(),
                author: dSnap.data['author'].toString(),
                imagePath: dSnap.data['imagePath'].toString(),
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

  Future<bool> uploadBook({@required Book book, @required String uid}) async {
    try {
      await Firestore.instance.collection("books").add({
        'author': book.author,
        'title': book.title,
        'isbn': book.isbn,
        'imagePath': book.imagePath,
        'uid': uid,
      });
    } catch (e) {
      return false;
    }
    return true;
  }
}
