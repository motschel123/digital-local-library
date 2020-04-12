import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_local_library/models/chat_model.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String peerId;
  final String peerAvatar;

  ChatScreen({@required this.peerId, @required this.peerAvatar});

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
            child: StreamBuilder<List<DocumentSnapshot>>(
                stream: ChatModel().stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      reverse: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return MessageWidget();
                      },
                    );
                  }
                  return CircularProgressIndicator();
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
