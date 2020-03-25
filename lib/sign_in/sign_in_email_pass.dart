import 'package:digital_local_library/sign_in/auth_provider.dart';
import 'package:flutter/material.dart';

class SignInEmailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              child: Text("Coming soon..."),
              onPressed: () async {
                if ((await AuthProvider.of(context).signInWithGoogle()) !=
                    null) {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
