import 'package:digital_local_library/data/chat.dart';
import 'package:digital_local_library/firebase_interfaces/chatting.dart';
import 'package:digital_local_library/models/chats_model.dart';
import 'package:digital_local_library/screens/chats/chat_screen.dart';
import 'package:digital_local_library/sign_in/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ChatsOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chats")),
      body: FutureBuilder<Stream<List<Chat>>>(
          future: ChattingInterface(
                  currentUser: AuthProvider.of(context).currentUser())
              .getActiveChats,
          builder: (context, futureSnap) {
            return futureSnap.hasData
                ? StreamBuilder<List<Chat>>(
                    stream: futureSnap.data,
                    builder: (context, chatSnap) {
                      if (!chatSnap.hasData) {
                        return CircularProgressIndicator();
                      } else if (chatSnap.data.length == 0) {
                        return Center(
                          child: Text('No Chats Yet'),
                        );
                      }
                      return Center(
                        child: ListView.builder(
                          itemCount: chatSnap.data.length,
                          itemBuilder: (context, index) => ChatCard(
                            chat: chatSnap.data[index],
                          ),
                        ),
                      );
                    },
                  )
                : CircularProgressIndicator();
          }),
    );
  }
}

class ChatCard extends StatelessWidget {
  final Chat chat;

  ChatCard({@required this.chat}) : assert(chat != null);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              chat: chat,
            ),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.all(0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.scaleDown,
                  image: NetworkImage(chat.peerAvatarURL),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                children: <Widget>[
                  Text(
                    chat.peerName,
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
