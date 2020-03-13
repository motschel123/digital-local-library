import 'package:digital_local_library/models/appbar_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:digital_local_library/data/book.dart';
import 'package:digital_local_library/models/books_database_model.dart';
import 'package:digital_local_library/widgets/book_card.dart';

class BookFeed extends StatefulWidget {
  @override
  _BookFeedState createState() => _BookFeedState();
}

class _BookFeedState extends State<BookFeed> {
  List<Book> books = [];
  String searchText = "";
  // TODO: FIX THIS SHIT

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<BooksDatabaseModel>(
      rebuildOnChange: false,
      builder: (context, child, booksModel) {
        books = booksModel.books;
        return RefreshIndicator(
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: <Widget>[
              _createFeed(),
            ],
          ),
          onRefresh: () {
            setState(() {
              books = booksModel.books;
            });
            return Future<void>(() {});
          },
        );
      },
    );
  }

  Widget _createFeed() {
    List<Book> filteredBooks = List<Book>.from(books);
    if (books.length == 0) {
      return LinearProgressIndicator();
    } else {
      filteredBooks.retainWhere((Book b) {
        (b.title + " " + b.author).toLowerCase().contains(searchText.toLowerCase());
      });
    }
    return ExpansionPanelList.radio(
      children: filteredBooks.map((Book b) {
        return new BookCard(
          key: GlobalKey(),
          book: b,
          value: b.isbn,
        );
      }).toList(),
    );
  }
}
