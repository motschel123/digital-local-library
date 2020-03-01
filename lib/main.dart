import 'package:digital_local_library/screens/landing_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:digital_local_library/consts/Consts.dart';
import 'package:digital_local_library/models/firebase_auth_model.dart';
import 'package:scoped_model/scoped_model.dart';

void main () => runApp(MyApp());

class MyApp extends StatelessWidget {
    @override
    Widget build (BuildContext context) {
        return MaterialApp(
            title: Consts.HOMESCREEN_TITLE,
            theme: ThemeData(
                primaryColor: Colors.red[400],
                accentColor: Colors.greenAccent,
                textTheme: TextTheme(),
            ),
            home: ScopedModel<FirebaseAuthModel>(
                model: FirebaseAuthModel(),
                child: LandingScreen(),
            ),
        );
    }
}
