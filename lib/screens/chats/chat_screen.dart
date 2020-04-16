import 'package:digital_local_library/data/chat.dart';
import 'package:digital_local_library/data/message.dart';
import 'package:digital_local_library/models/messages_model.dart';
import 'package:digital_local_library/sign_in/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ChatScreen extends StatefulWidget {
  final Chat chat;

  ChatScreen({Key key, @required this.chat})
      : assert(chat != null),
        super(key: key);

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
      model: MessagesModel(chat: widget.chat),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.scaleDown,
                    image: NetworkImage(widget.chat.peerAvatarURL),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
              Text(widget.chat.peerName),
            ],
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: ScopedModelDescendant<MessagesModel>(
                builder: (context, _, messagesModel) {
                  return Center(
                    child: messagesModel.messages.isEmpty
                        ? ListView(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    color: Theme.of(context).accentColor,
                                  ),
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "No messages yet",
                                    textScaleFactor: 2,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            itemCount: messagesModel.messages.length,
                            itemBuilder: (context, index) {
                              return MessageWidget(
                                message:
                                    messagesModel.messages.elementAt(index),
                                peerName: messagesModel.chat.peerName,
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
                  Builder(
                    builder: (context) => RawMaterialButton(
                      child: Icon(Icons.send),
                      shape: CircleBorder(),
                      fillColor: Colors.cyan,
                      onPressed: () async {
                        if (_formStateKey.currentState.validate()) {
                          await ScopedModel.of<MessagesModel>(context,
                                  rebuildOnChange: false)
                              .newMessage(
                            Message(
                              dateTime: DateTime.now(),
                              text: _msgCtr.text,
                              username:
                                  (await AuthProvider.of(context).currentUser())
                                      .displayName,
                            ),
                          );
                          _msgCtr.clear();
                        }
                        FocusScope.of(context).unfocus();
                      },
                    ),
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
  static const Color COLOR_PEER = Colors.grey;
  static const Color COLOR_USER = Colors.lightGreen;

  final Message message;
  final String peerName;

  MessageWidget({@required this.message, @required this.peerName});

  @override
  Widget build(BuildContext context) {
    final bool isLeft = message.username == peerName;
    return Container(
      alignment: isLeft ? Alignment.topLeft : Alignment.topRight,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Card(
        color: message.username == peerName ? COLOR_PEER : COLOR_USER,
        child: Container(
          padding: EdgeInsets.all(8.0),
          constraints: BoxConstraints(maxWidth: 250),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(message.text),
              Text(
                message.dateTime.hour.toString() +
                    ":" +
                    message.dateTime.minute.toString(),
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}