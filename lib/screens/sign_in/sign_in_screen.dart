import 'package:digital_local_library/sign_in/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter/services.dart';

class SignInScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final bool anonymousSignIn;

  SignInScreen({Key key, @required this.anonymousSignIn}) : super(key: key);

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
                } on PlatformException catch (e) {
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
                Navigator.pushNamed(context, '/sign_in/email');
              },
              text: "Sign in with email",
            ),
            anonymousSignIn
                ? MaterialButton(
                    child: Text("Skip for now"),
                    onPressed: () async {
                      try {
                        AuthProvider.of(context).signInAnonymously();
                      } catch (e) {
                        print(e);
                      }
                    },
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
