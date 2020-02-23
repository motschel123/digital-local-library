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
          .map(
            (dSnap) => new Book(dSnap.data['name'], dSnap.data['author'],
                dSnap.data['imagePath']),
          )
          .toList().reversed.toList();
    });
  }

  void updateBooks() {
    notifyListeners();
  }

  Future<bool> uploadBook({@required isbn}) async {
    return true;
  }
}
