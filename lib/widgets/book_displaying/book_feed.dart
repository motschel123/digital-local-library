import 'package:digital_local_library/models/appbar_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:digital_local_library/data/book.dart';
import 'package:digital_local_library/models/books_database_model.dart';
import 'package:digital_local_library/widgets/book_displaying/book_card.dart';

class BookFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppBarModel>(
      rebuildOnChange: true,
      builder: (context, child, appBarModel) {
        return ScopedModelDescendant<BooksDatabaseModel>(
          rebuildOnChange: true,
          builder: (context, child, booksModel) {
            return RefreshIndicator(
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: <Widget>[_createFeed(booksModel.books, appBarModel.searchText)],
              ),
              onRefresh: () {
                return booksModel.updateBooks();
              },
            );
          },
        );
      },
    );
  }

  Widget _createFeed(List<Book> books, String searchText) {
    List<Book> filteredBooks = List<Book>.from(books);
    filteredBooks.retainWhere((Book book) => book.containsString(searchText));

    return ExpansionPanelList.radio(
      key: UniqueKey(),
      children: List<ExpansionPanelRadio>.generate(
        filteredBooks.length,
        (int index) {
          Book tempBook = filteredBooks[index];
          return BookCard(book: tempBook, value: index);
        },
      ),
    );
  }
}
