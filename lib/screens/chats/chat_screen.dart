import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_local_library/data/message.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String peerName;
  final String peerPhotoUrl;
  final DocumentSnapshot chatDocument;

  ChatScreen(
      {@required this.peerName,
      @required this.peerPhotoUrl,
      @required this.chatDocument});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _msgCtr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: StreamBuilder<List<Message>>(
                stream: widget.chatDocument.reference
                    .collection('messages')
                    .orderBy('timestamp')
                    .limit(10)
                    .snapshots()
                    .map<List<Message>>(
                      (querySnapshot) => querySnapshot.documents.map<Message>(
                        (dSnap) => Message(
                          text: dSnap.data['text'],
                          username: '',
                          timestamp: dSnap.data['timestamp'],
                        ),
                      ),
                    ),
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) =>
                              Text(snapshot.data.elementAt(index).text),
                        )
                      : Center(child: CircularProgressIndicator());
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    controller: _msgCtr,
                  ),
                ),
                RawMaterialButton(
                  child: Icon(Icons.send),
                  shape: CircleBorder(),
                  fillColor: Colors.cyan,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  MessageWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(7.0),
      padding: EdgeInsets.all(8.0),
      color: Colors.lightGreen,
      alignment: Alignment.topLeft,
      child: Container(
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Text("Hello Marcel"),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "14:11",
                style: TextStyle(fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
