import 'package:flutter/material.dart';
import 'package:digital_local_library/data/book.dart';

class BookCard extends Card {
    BookCard (this.book);

    final Book book;

    @override
    Widget build (BuildContext context) {
        return GestureDetector(
            onTap: () {
                // TODO: open bookdetailscreen
            },

            child: Card(
                child: Container(
                    height: 120.0,
                    margin: EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 16.0
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                            Container(
                                alignment: FractionalOffset.centerLeft,
                                child: Image(
                                    image: NetworkImage(book.imagePath),
                                ),
                            ),
                            Expanded(
                                child: Container(
                                    height: 120.0,
                                    margin: EdgeInsets.only(
                                        left: 16.0,
                                    ),
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                            Text(
                                                book.title,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.bold,
                                                ),
                                            ),
                                            Text(
                                                book.author,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                ),
                                            ),
                                        ],
                                    ),
                                ),
                            ),
                        ],
                    ),
                ),
            ),
        );
    }
}
