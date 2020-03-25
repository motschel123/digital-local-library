import 'package:digital_local_library/sign_in/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

enum SignState { base, signInGoogle, signInEmail, signUpEmail }

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SignInButton(
              Buttons.Google,
              onPressed: () async {
                try {
                  await AuthProvider.of(context).signInWithGoogle();
                } catch (e) {
                  
                  print(e);
                }
              },
              text: "Sign in with google",
            ),
            true? Container(): SignInButton(
              Buttons.Email,
              onPressed: () async {
                Navigator.pushNamed(context, '/sign_in/email');
              },
              text: "Sign in with email",
            ),
          ],
        ),
      ),
    );
  }
}
