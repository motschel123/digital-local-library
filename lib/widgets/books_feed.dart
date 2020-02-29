import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:digital_local_library/data/book.dart';
import 'package:digital_local_library/models/books_database_model.dart';
import 'package:digital_local_library/widgets/book_card.dart';

class BooksFeed extends StatelessWidget {
  final String _searchText;

  BooksFeed(this._searchText);

  Widget _createExpansionPanelList(BooksDatabaseModel booksModel) {
    if (booksModel.books.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 50.0),
          child: Text(
            "Pull down to refresh!",
            textScaleFactor: 1.8,
          ),
        ),
      );
    }
    List<Book> filteredBooks = booksModel.books.map((Book book) {
      if (_searchBookAgainstString(book, _searchText)) {
        return book;
      }
    }).toList();
    
    return ExpansionPanelList.radio(
      children: List<ExpansionPanelRadio>.generate(
        filteredBooks.length,
        (int index) {
          Book tempBook = filteredBooks[index];
          if(tempBook == null) return null;
          return BookCard(book: tempBook, value: index);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ScopedModelDescendant<BooksDatabaseModel>(
        rebuildOnChange: true,
        builder: (context, child, booksModel) {
          return RefreshIndicator(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: _createExpansionPanelList(booksModel),
            ),
            onRefresh: () {
              booksModel.updateBooks();
              return Future<void>(() {});
            },
          );
        },
      ),
    );
  }

  bool _searchBookAgainstString(Book book, String searchText) {
    if (searchText.isEmpty ||
        (book.title + " " + book.author).toLowerCase().contains(searchText)) {
      return true;
    }
    return false;
  }
}
