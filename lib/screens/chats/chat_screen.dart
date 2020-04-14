import 'package:digital_local_library/data/chat.dart';
import 'package:digital_local_library/data/message.dart';
import 'package:digital_local_library/models/messages_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ChatScreen extends StatefulWidget {
  final Chat chat;

  ChatScreen({Key key, @required this.chat}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  final TextEditingController _msgCtr = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MessagesModel>(
      model: MessagesModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Chat"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: ScopedModelDescendant<MessagesModel>(
                builder: (context, widget, messagesModel) {
                  return Center(
                    child: messagesModel.messages.isEmpty
                        ? ListView(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(8.0),
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    'No messages yet',
                                  ))
                            ],
                          )
                        : ListView.builder(
                            itemCount: messagesModel.messages.length,
                            itemBuilder: (context, index) {
                              return MessageWidget(
                                message:
                                    messagesModel.messages.elementAt(index),
                              );
                            },
                          ),
                  );
                },
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
                  RawMaterialButton(
                    child: Icon(Icons.send),
                    shape: CircleBorder(),
                    fillColor: Colors.cyan,
                    onPressed: () {
                      if (_formStateKey.currentState.validate()) {
                        // ScopedModel.of<MessagesModel>(context);
                        _msgCtr.clear();
                      }
                      FocusScope.of(context).unfocus();
                    },
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
