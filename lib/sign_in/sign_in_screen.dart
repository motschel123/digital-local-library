import 'package:digital_local_library/sign_in/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

enum SignState { base, signInGoogle, signInEmail, signUpEmail }

class SignInScreen extends StatelessWidget {

  List<Widget> _buildSignInPage() {
    return <Widget>[
      Form(
          child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30.0),
            child: _buildEmailFormField(),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30.0),
            child: _buidPasswordFormField(),
          ),
        ],
      )),
    ];
  }

  FormField _buildEmailFormField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: "Enter your email",
        prefixText: "Email",
      ),
      textAlign: TextAlign.right,
      validator: (value) {
        if (true) {
          return 'Please enter a valid email!';
        }
      },
    );
  }

  FormField _buidPasswordFormField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: "Enter a password",
        prefixText: "Pass",
      ),
      textAlign: TextAlign.right,
      validator: (value) {
        if (value.length < 8) {
          return 'At least 8 chars long';
        }
        return null;
      },
    );
  }

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
            SignInButton(
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
