import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:digital_local_library/data/book.dart';
import 'package:digital_local_library/models/books_database_model.dart';
import 'package:digital_local_library/widgets/book_card.dart';

class BooksFeed extends StatelessWidget {
  final String searchText;

  BooksFeed({this.searchText});

  Widget _createFeed(BooksDatabaseModel booksModel) {
    if (booksModel.books.isEmpty) {
      return Center(
        child: Text(
          "Pull down to refresh books!",
        ),
      );
    }

    List<Book> filteredBooks = List.from(booksModel.books);
    filteredBooks.retainWhere((Book book) => book.containsString(searchText));

    return ExpansionPanelList.radio(
      children: List<ExpansionPanelRadio>.generate(
        filteredBooks.length,
        (int index) {
          Book tempBook = filteredBooks[index];
          return BookCard(book: tempBook, value: index);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<BooksDatabaseModel>(
      rebuildOnChange: true,
      builder: (context, child, booksModel) {
        return RefreshIndicator(
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: <Widget>[_createFeed(booksModel)],
          ),
          onRefresh: () {
            booksModel.updateBooks();
            return Future<void>(() {});
          },
        );
      },
    );
  }
}
