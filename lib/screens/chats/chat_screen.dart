import 'package:digital_local_library/data/message.dart';
import 'package:digital_local_library/models/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ChatScreen extends StatefulWidget {
  // final String peerName;
  // final String peerPhotoUrl;
  // final DocumentSnapshot chatDocument;

  ChatScreen({Key key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  final TextEditingController _msgCtr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ScopedModel<ChatModel>(
      model: ChatModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Chat"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: ScopedModelDescendant<ChatModel>(
                rebuildOnChange: true,
                builder: (context, widget, chatModel) => ListView.builder(
                  itemCount: chatModel.messages.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: MessageWidget(
                          message: chatModel.messages.elementAt(index)),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Form(
                      key: _formStateKey,
                      child: TextFormField(
                        controller: _msgCtr,
                        validator: (text) {
                          return text.isEmpty ? "" : null;
                        },
                      ),
                    ),
                  ),
                  ScopedModelDescendant<ChatModel>(
                    rebuildOnChange: false,
                    builder: (context, widget, model) {
                      return RawMaterialButton(
                        child: Icon(Icons.send),
                        shape: CircleBorder(),
                        fillColor: Colors.cyan,
                        onPressed: () {
                          if(_formStateKey.currentState.validate()){
                            model.newMessage(Message(text: _msgCtr.text, username: "Marcel", dateTime: DateTime.now()));
                            _msgCtr.clear();
                          }
                          FocusScope.of(context).unfocus();
                        },
                      );
                    }
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

class MessageWidget extends StatelessWidget {
  final Message message;

  MessageWidget({@required this.message});

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
              child: Text(message.text),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                message.dateTime.hour.toString() +
                    ":" +
                    message.dateTime.minute.toString(),
                style: TextStyle(fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
