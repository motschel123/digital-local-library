import 'package:digital_local_library/sign_in/auth_provider.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body: MaterialButton(
        child: Text("Sign out"),
        onPressed: () async {
        AuthProvider.of(context).signOut();
      }),
      appBar: AppBar(
        title: Text('Settings'),
      ),
    );
  }
} 