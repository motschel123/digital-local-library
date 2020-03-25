import 'dart:developer';

import 'package:digital_local_library/screens/sign_in/sign_in_email_screen.dart';
import 'package:digital_local_library/sign_in/auth.dart';
import 'package:digital_local_library/sign_in/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

class SignInScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  SignInScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SignInButton(
              Buttons.Google,
              onPressed: () async {
                try {
                  await AuthProvider.of(context).signInWithGoogle();
                  Navigator.popUntil(
                    context,
                    ModalRoute.withName('/home'),
                  );
                } on AuthException catch (e) {
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text(e.message),
                  ));
                }
              },
              text: "Sign in with google",
            ),
            SignInButton(
              Buttons.Email,
              onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SignInEmailScreen()));
              },
              text: "Sign in with email",
            ),
            /*MaterialButton(
              child: Text("Skip for now"),
              onPressed: () async {
                try {
                  AuthProvider.of(context).signInAnonymously();
                  Navigator.popUntil(
                      context, ModalRoute.withName('/home'));
                } on AuthException catch (e) {
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text(e.message),
                  ));
                }
              },
            )*/
          ],
        ),
      ),
    );
  }
}
