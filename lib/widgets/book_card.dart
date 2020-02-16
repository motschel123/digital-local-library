import 'package:flutter/material.dart';

class BookCard extends Card {
  BookCard(this.bookImagePath);

  final String bookImagePath;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: ContinuousRectangleBorder(),
      child: GestureDetector(
        child: Container(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 400,
            ),
            child: SizedBox.expand(
              child: Image(image: AssetImage(bookImagePath)),
            ),
          ),
        ),
      ),
      margin: EdgeInsets.all(10),
    );
  }
}
