import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:digital_local_library/data/book.dart';
import 'package:digital_local_library/models/books_database_model.dart';
import 'package:digital_local_library/widgets/book_card.dart';


class BooksFeed extends StatelessWidget {
    final String _searchText;

    BooksFeed (this._searchText);

    Widget _createExpansionPanelList (BooksDatabaseModel booksModel) {
        if (booksModel.books.isEmpty) {
            return SingleChildScrollView(
                child:  Center(child: Text("Pull down to refresh!"),),
            );
        }
        return SingleChildScrollView(
            child: Container (child: ExpansionPanelList.radio(
            children: List<ExpansionPanelRadio>
                .generate(
                    booksModel.books.length, 
                    (int index) {
                        Book tempBook = booksModel.books[index];
                if (_searchBookAgainstString(tempBook, _searchText)) {
                    return BookCard(book: tempBook);
                } else
                    return null;
                    },
                ),
        )));
    }

    @override
    Widget build (BuildContext context) {
        return ScopedModelDescendant<BooksDatabaseModel>(
            rebuildOnChange: true,
            builder: (context, child, booksModel) {
                return RefreshIndicator(
                    child: _createExpansionPanelList(booksModel),
                    onRefresh: () {
                        booksModel.updateBooks();
                        return Future<void>(() {});
                    },
                );
            },
        );
    }

    bool _searchBookAgainstString (Book book, String searchText) {
        if (searchText.isEmpty ||
            (book.title + " " + book.author).toLowerCase().contains(searchText)) {
            return true;
        }
        return false;
    }
}
