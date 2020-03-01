import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:digital_local_library/models/firebase_auth_model.dart';
import 'package:scoped_model/scoped_model.dart';

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SignInButton(
              Buttons.Google,
              onPressed: () async {
                  await ScopedModel.of<FirebaseAuthModel>(context).signInWithGoogle();
              },
              text: "Sign in with google",
            ),
          ],
        ),
      ),
    );
  }
}
