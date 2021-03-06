import 'package:digital_local_library/sign_in/user.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BookBase {
  final String title;
  final String author;
  final String imagePath;
  final String isbn;

  String _description = "";

  BookBase(
      {@required this.isbn,
      @required this.title,
      @required this.author,
      @required this.imagePath,
      String description}) {
    _description = description;
  }

  String get description => _description;

  static Future<BookBase> getByIsbn(String isbn) async {
    // Encode url and fetch result from API
    String bookUrl = Uri.encodeFull(
        "https://www.googleapis.com/books/v1/volumes?q=isbn:" + isbn);
    var res = await http.get(bookUrl);

    if (res.statusCode == 200) {
      var jsonData = json.decode(res.body);

      // Check whether a book with this ISBN exists
      if (jsonData['totalItems'] > 0) {
        var bookData = jsonData['items'][0]['volumeInfo'];

        String _bookTitle = bookData['title'];
        String _bookAuthor =
            bookData.containsKey('authors') ? bookData['authors'][0] : "";
        String _bookThumbnail = bookData.containsKey('imageLinks')
            ? bookData['imageLinks']['thumbnail']
            : "";
        String _bookDescription = bookData.containsKey('description') ? bookData['description'] : "";
        String _bookIsbn = bookData['industryIdentifiers'][1]['identifier'];

        return BookBase(
          title: _bookTitle,
          author: _bookAuthor,
          imagePath: _bookThumbnail,
          description: _bookDescription,
          isbn: _bookIsbn,
        );
      } else {
        throw Exception('No book was found with this ISBN');
      }
    } else {
      throw Exception("Failed to load book from API");
    }
  }
}

class Book extends BookBase {
  final String title;
  final String author;
  final String imagePath;
  final String isbn;
  final String owner;

  Book({
    @required this.isbn,
    @required this.title,
    @required this.author,
    @required this.imagePath,
    @required this.owner,
    String description
  }) {
    this._description = description;
  }

  bool containsString(String str) {
    if (str.isEmpty ||
        (title + " " + author)
            .toLowerCase()
            .replaceAll(" ", "")
            .contains(str.toLowerCase().replaceAll(" ", ""))) {
      return true;
    }
    return false;
  }

  static bool checkIsbn(String isbn) {
    isbn = isbn.replaceAll("-", "").replaceAll(" ", "");
    if (isbn.length == 13) {
      return _check13isbn(isbn);
    } else if (isbn.length == 10) {
      return _check10isbn(isbn);
    }
    return false;
  }

  static bool _check13isbn(String isbn) {
    int checkDigit = int.parse(isbn[isbn.length - 1]);
    isbn = isbn.substring(0, isbn.length - 1);
    List<String> chars = isbn.split("");

    int sum = 0;
    int swapper = 1;
    for (String char in chars) {
      sum = sum + int.parse(char) * swapper;
      swapper = swapper == 1 ? 3 : 1;
    }
    int mod = sum % 10;
    if (mod == 0) {
      return true;
    }
    if (10 - mod == checkDigit) {
      return true;
    }
    return false;
  }

  static bool _check10isbn(String isbn) {
    List<String> chars = isbn.split("").reversed.toList();

    int sum = 0;
    for (int i = 0; i < 10; i++) {
      sum = sum + int.parse(chars[i]) * (i + 1);
    }
    print(sum);
    int mod = sum % 11;
    if (mod == 0) {
      return true;
    }
    return false;
  }
}
