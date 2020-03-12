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

  // TODO: FIX THIS SHIT
  List<ExpansionPanelRadio> bookPanels = [];

  List<ExpansionPanelRadio> getBookPanels(List<Book> books, String search) {
    List<Book> filteredBooks = List<Book>.from(books);
    filteredBooks.retainWhere((Book book) => book.containsString(search));

    return new List.unmodifiable(
        filteredBooks.map<ExpansionPanelRadio>((Book book) {
      return new BookCard(
        book: book,
        value: filteredBooks.indexOf(book),
      );
    }).toList());
  }

  _BookFeedState(){
    bookPanels = getBookPanels(books, "");
  }

  @override
  void initState() {
    super.initState();

    AppBarModel appBarModel = ScopedModel.of<AppBarModel>(context);

    appBarModel.addListener(() {
      setState(() {
        bookPanels = getBookPanels(books, appBarModel.searchText);
      });
    });
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
              _createFeed(
                books,
              ),
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

  Widget _createFeed(List<Book> books) {
    if (bookPanels.length == 0) {
      return LinearProgressIndicator();
    }
    return ExpansionPanelList.radio(
      children: bookPanels,
    );
  }
}
