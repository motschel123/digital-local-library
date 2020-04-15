import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_local_library/data/chat.dart';
import 'package:digital_local_library/data/message.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class MessagesModel extends Model {
  CollectionReference _messagesRef;
  final Chat chat;

  List<Message> _messages = <Message>[];
  List<Message> get messages => _messages;

  MessagesModel({@required this.chat}) : assert(chat != null) {
    _messagesRef =
        Firestore.instance.collection('chats/${chat.chatDocumentId}/messages');
    _messagesRef.snapshots().map((querySnap) {
      if (querySnap.documents.isNotEmpty) {
        List<Message> messages = <Message>[];
        querySnap.documents.forEach((documentSnap) {
          messages.add(Message.fromMap(documentSnap.data));
        });
        return messages;
      }
      return <Message>[];
    }).listen((messages) {
      _messages = messages;
      notifyListeners();
    });
  }

  Future<DocumentSnapshot> newMessage(Message message) {
    _messagesRef.add(message.toMap());
  }

  static MessagesModel of(BuildContext context) =>
      ScopedModel.of<MessagesModel>(context);
}
