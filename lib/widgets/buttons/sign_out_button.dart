import 'package:digital_local_library/sign_in/auth_provider.dart';
import 'package:flutter/material.dart';

class SignOutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: Text("Sign out"),
      onPressed: () async {
        AuthProvider.of(context).signOut();
      },
    );
  }
}
