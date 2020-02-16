import 'package:digital_local_libary/screens/home.dart';
import 'package:digital_local_libary/consts/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


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
      home: HomeScreen(),
    );
  }
}
