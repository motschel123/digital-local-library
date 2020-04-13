import 'dart:developer' as developer;
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_local_library/screens/chats/chat_screen.dart';
import 'package:digital_local_library/sign_in/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:digital_local_library/sign_in/user.dart';

class ChatsOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chats")),
      body: Center(
        child: FutureBuilder<String>(
          future: AuthProvider.of(context)
              .currentUser()
              .then((CurrentUser currentUser) => currentUser.uid),
          builder: (context, uidSnapshot) {
            return !uidSnapshot.hasData
                ? CircularProgressIndicator()
                : StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection('users')
                        .document(uidSnapshot.data)
                        .collection('chats')
                        .snapshots(),
                    builder: (context, chatsSnapshot) {
                      if (chatsSnapshot.hasError) {
                        developer.log(chatsSnapshot.error.toString());
                      }
                      return Center(
                        child: !chatsSnapshot.hasData
                            ? CircularProgressIndicator()
                            : ListView.builder(
                                padding: EdgeInsets.all(10.0),
                                itemCount: chatsSnapshot.data.documents.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot doc = chatsSnapshot
                                      .data.documents
                                      .elementAt(index);
                                  Map<String, dynamic> data = doc.data;
                                  return ChatCard(
                                    document: doc,
                                    peerName: data['peerName'],
                                    photoUrl: data['photoUrl'],
                                    latestMessage: data['latestMessage'],
                                    latestMessageFrom:
                                        data['latestMessageFrom'],
                                    latestMessageTimestamp:
                                        data['latestMessageTimestamp'],
                                  );
                                }),
                      );
                    },
                  );
          },
        ),
      ),
    );
  }

  Widget _testNewChat(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chats")),
      body: Center(
        child: MaterialButton(
          child: Text("new chat"),
          onPressed: () {
            
          },
        ),
      ),
    );
  }
}

class ChatCard extends StatelessWidget {
  final DocumentSnapshot document;
  final String peerName;
  final String photoUrl;
  final String latestMessage;
  final String latestMessageFrom;
  final Timestamp latestMessageTimestamp;

  /// DocumentSnapshot requires following key:value pairs
  /// 'peerName', 'latestMessage', 'latestMessageFrom', 'photoUrl'
  ChatCard(
      {@required this.document,
      @required this.peerName,
      @required this.photoUrl,
      @required this.latestMessage,
      @required this.latestMessageFrom,
      @required this.latestMessageTimestamp})
      : assert(document != null),
        assert(peerName != null),
        assert(photoUrl != null),
        assert(latestMessage != null),
        assert(latestMessageFrom != null),
        assert(latestMessageTimestamp != null);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(
                    peerName: peerName,
                    peerPhotoUrl: photoUrl,
                    chatDocument: document)));
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
                  image: NetworkImage(photoUrl),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                children: <Widget>[
                  Text(
                    peerName,
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(latestMessage.substring(
                          0, math.min(latestMessage.length, 12)) +
                      '...')
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
