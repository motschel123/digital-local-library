import 'package:digital_local_library/models/firebase_auth_model.dart';
import 'package:digital_local_library/screens/home_screen.dart';
import 'package:digital_local_library/screens/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class LandingScreen extends StatelessWidget {  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseAuthModel>(
        builder: (BuildContext context, AsyncSnapshot<FirebaseAuthModel> snapshot) {
            return snapshot.hasData ? HomeScreen() : SignInScreen();
        },

    );
  }
}