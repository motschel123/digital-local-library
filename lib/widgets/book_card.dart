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
                elevation: 1,
                shape: ContinuousRectangleBorder(),
                child: GestureDetector(
                    child: Container(
                        child: ConstrainedBox(
                            constraints: BoxConstraints(
                                maxHeight: 400,
                            ),
                            child: SizedBox.expand(
                                child: Image(image: NetworkImage(book.imagePath)),
                            ),
                        ),
                    ),
                ),
                margin: EdgeInsets.all(10),
            ),
        );
    }
}
