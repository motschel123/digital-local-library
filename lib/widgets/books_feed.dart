import 'package:digital_local_libary/book.dart';
import 'package:digital_local_libary/models/books_model.dart';
import 'package:digital_local_libary/widgets/book_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

<<<<<<< HEAD
class BooksFeed extends StatelessWidget {
  final String _searchText;

  BooksFeed(this._searchText);
=======
class BooksFeed extends StatefulWidget {
  final String _filter;
  
  BooksFeed(this._filter);

  @override
  State<StatefulWidget> createState() => new BooksFeedState();
}

class BooksFeedState extends State<BooksFeed> {
  List<String> bookImagePaths;

  @override
  void initState() {
    super.initState();
    getNewData2();
  }
>>>>>>> master

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
<<<<<<< HEAD
  
  bool _searchBookAgainstString(Book book, String searchText) {
    if(searchText.isEmpty || (book.title + " " + book.author).toLowerCase().contains(searchText)) {
      return true;
    }
    return false;
=======

  Future<Null> getNewData() async{
    //TODO: add filter
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      bookImagePaths = ["assets/testData/cafe-am-rande.jpg", "assets/testData/kaffee.jpg"];
    });
    return null;
  }

  Future<Null> getNewData2() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      bookImagePaths = ["assets/testData/kaffee.jpg"];
    });
    return null;
>>>>>>> master
  }
}
