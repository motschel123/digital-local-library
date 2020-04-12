import 'package:digital_local_library/screens/chats/chats_overview_screen.dart';
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatsOverviewScreen(),
                  ),
                );
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
