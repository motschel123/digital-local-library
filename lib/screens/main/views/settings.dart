import 'package:digital_local_library/data/chat.dart';
import 'package:digital_local_library/screens/chats/chat_screen.dart';
import 'package:digital_local_library/sign_in/auth_provider.dart';
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
                    builder: (context) => ChatScreen(),
                  ),
                );
              }),
          MaterialButton(
            child: Text("new chat"),
            onPressed: () async {
              Chat.newChat(
                peerDisplayName: "marcel schöckel",
                currentUserDisplayName:
                    (await AuthProvider.of(context).currentUser()).displayName,
              );
            },
          ),
          SignOutButton(),
        ],
      ),
      appBar: AppBar(
        title: Text('Settings'),
      ),
    );
  }
}
