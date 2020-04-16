import 'package:digital_local_library/data/book.dart';
import 'package:digital_local_library/sign_in/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BooksDatabaseModel extends Model {
  static const String FIELD_TITLE = 'title';
  static const String FIELD_OWNER = 'owner';
  static const String FIELD_ISBN = 'isbn';
  static const String FIELD_IMAGE_PATH = 'imagePath';
  static const String FIELD_DESCRIPTION = 'description';
  static const String FIELD_AUTHOR = 'author';

  Stream<QuerySnapshot> _stream;

  List<Book> _books = [];

  List<Book> get books => _books;

  BooksDatabaseModel() {
    _stream = Firestore.instance.collection("books").snapshots();
    _stream.listen((querySnapshot) {
      _books = querySnapshot.documents
          .map((dSnap) {
            // Description is an optional property
            String bookDescription = dSnap.data.containsKey(FIELD_DESCRIPTION)
                ? dSnap.data[FIELD_DESCRIPTION]
                : "";

            return new Book(
                isbn: dSnap.data[FIELD_ISBN].toString(),
                title: dSnap.data[FIELD_TITLE].toString(),
                author: dSnap.data[FIELD_AUTHOR].toString(),
                imagePath: dSnap.data[FIELD_IMAGE_PATH].toString(),
                description: bookDescription,
                owner: OtherUser.fromMap(dSnap.data[FIELD_OWNER]));
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
        'owner': book.owner,
      });
    } catch (e) {
      return false;
    }
    return true;
  }
}
