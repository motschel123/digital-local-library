import 'package:digital_local_libary/models/books_model.dart';
import 'package:digital_local_libary/widgets/book_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class BooksFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<BooksModel>(
      builder: (context, child, model) {
        return RefreshIndicator(
          child: ListView.builder(
            itemCount: model.books.length,
            itemBuilder: (BuildContext context, int index) {
              return BookCard(model.books[index]);
            },
          ),
          onRefresh: () {
            model.updateBooks();
            return Future<void>((){});
          },
        );
      },
    );
  }
}
