import 'package:digital_local_library/widgets/buttons/sign_out_button.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          MaterialButton(
              child: Text("Chat"),
              onPressed: () {
                Navigator.pushNamed(context, '/home/chats');
              }),
          SignOutButton(),
        ],
      ),
      appBar: AppBar(
        title: Text('Settings'),
      ),
    );
  }
}
