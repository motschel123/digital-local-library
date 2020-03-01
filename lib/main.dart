import 'package:digital_local_library/screens/landing_screen.dart';
import 'package:digital_local_library/sign_in/auth.dart';
import 'package:digital_local_library/sign_in/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:digital_local_library/consts/Consts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      auth: Auth(),
      child: MaterialApp(
        title: Consts.HOMESCREEN_TITLE,
        theme: ThemeData(
          primaryColor: Colors.red[400],
          accentColor: Colors.greenAccent,
          textTheme: TextTheme(),
        ),
        home: LandingScreen(),
      ),
    );
  }
}
