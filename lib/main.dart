import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:digital_local_library/consts/Consts.dart';
import 'package:digital_local_library/screens/home_screen.dart';
import 'package:digital_local_library/models/books_database_model.dart';
import 'package:digital_local_library/models/appbar_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Consts.HOMESCREEN_TITLE,
      theme: ThemeData(
        primaryColor: Colors.red[400],
        accentColor: Colors.greenAccent,
        textTheme: TextTheme(),
      ),
      home: HomeScreen(
        books: BooksDatabaseModel(),
        searchBar: AppBarModel(),
      ),
    );
  }
}
