import 'package:digital_local_library/models/appbar_model.dart';
import 'package:digital_local_library/screens/home_screen.dart';
import 'package:digital_local_library/consts/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:digital_local_library/models/books_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.MAIN_TITLE,
      theme: ThemeData(
        primaryColor: Colors.red[400],
        accentColor: Colors.greenAccent,
        textTheme: TextTheme(),
      ),
      home: HomeScreen(books: BooksModel(), searchBar: AppBarModel(),),
    );
  }
}
