import 'package:digital_local_library/sign_in/auth.dart';
import 'package:digital_local_library/sign_in/auth_provider.dart';
import 'package:digital_local_library/sign_in/sign_in_screen.dart';
import 'package:digital_local_library/screens/main/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Auth auth = AuthProvider.of(context);
    return StreamBuilder(
        stream: auth.onAuthStateChanged,
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final bool loggedIn = snapshot.hasData;
            return loggedIn ? MainScreen() : SignInScreen();
          }
          return CircularProgressIndicator();
        });
  }
}
