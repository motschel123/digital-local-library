import 'package:digital_local_library/sign_in/auth_provider.dart';
import 'package:flutter/material.dart';

class SignOutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: AuthProvider.of(context).currentUser().asStream(),
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          if(snapshot.data.isAnonymous) {
            return MaterialButton(
              child: Text("Sign in"),
              onPressed: () {
                Navigator.pushNamed(context, '/home/sign_in');
              },
            );
          }
        }
        return MaterialButton(
          child: Text("Sign out"),
          onPressed: () async {
            AuthProvider.of(context).signOut();
          },
        );
      }
    );
  }
}
