import 'package:digital_local_library/book.dart';
import 'package:digital_local_library/models/books_model.dart';
import 'package:digital_local_library/widgets/book_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class BooksFeed extends StatelessWidget {
  final String _searchText;

  BooksFeed(this._searchText);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<BooksModel>(
      rebuildOnChange: true,
      builder: (context, child, booksModel) {
        return RefreshIndicator(
          child: ListView.builder(
            itemCount: booksModel.books.length,
            itemBuilder: (BuildContext context, int index) {
              Book tempBook = booksModel.books[index];
              if(_searchBookAgainstString(tempBook, _searchText)){
                return BookCard(tempBook);
              } else return null;
            },
          ),
          onRefresh: () {
            booksModel.updateBooks();
            return Future<void>((){});
          },
        );
      },
    );
  }
  
  bool _searchBookAgainstString(Book book, String searchText) {
    if(searchText.isEmpty || (book.title + " " + book.author).toLowerCase().contains(searchText)) {
      return true;
    }
    return false;
  }
}
