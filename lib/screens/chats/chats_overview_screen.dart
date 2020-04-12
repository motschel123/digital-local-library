import 'package:cloud_firestore/cloud_firestore.dart';
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
              .then((currentUser) => currentUser.documentId),
          builder: (context, documentIdSnapshot) {
            return !documentIdSnapshot.hasData
                ? CircularProgressIndicator()
                : StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection('users')
                        .document(documentIdSnapshot.data)
                        .collection('chats')
                        .snapshots(),
                    builder: (context, chatsSnapshot) {
                      return Center(
                          child: !chatsSnapshot.hasData
                              ? CircularProgressIndicator()
                              : ListView.builder(
                                  padding: EdgeInsets.all(10.0),
                                  itemCount:
                                      chatsSnapshot.data.documents.length,
                                  itemBuilder: (context, index) => Text(
                                    chatsSnapshot.data.documents
                                        .elementAt(index)
                                        .data['name'],
                                  ),
                                )
                          /*ChatCard(
                            peer: OtherUser.fromDocumentSnapshot(
                                documentSnapshot:
                                    snapshot.data.documents.elementAt(index)),
                          );*/
                          );
                    },
                  );
          },
        ),
      ),
    );
  }
}

class ChatCard extends StatelessWidget {
  final OtherUser peer;

  ChatCard({@required this.peer});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: Row(
          children: <Widget>[
            Text(peer.displayName),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(""),
            )
          ],
        ),
      ),
    );
  }
}
