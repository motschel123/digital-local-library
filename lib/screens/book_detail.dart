import 'package:digital_local_library/book.dart';
import 'package:flutter/material.dart';

class BookDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Book book;
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image(image: AssetImage(book.imagePath)),
          Text(book.title),
          Text(book.author),
        ]
      ),
    );
  }
}