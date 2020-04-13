import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_local_library/data/message.dart';
import 'package:flutter/material.dart';

class Chat {
  static newChat(
      {@required String peerDisplayName, @required String currentUserDisplayName}) async {
    Map<String, dynamic> data = {
      'peers': <String>[peerDisplayName, currentUserDisplayName],
    };
    List<Map<String, dynamic>> messages = <Map<String, dynamic>>[
      {'text': 'Hey marcel', 'timestamp': Timestamp.now()},
      {'text': 'hey', 'timestamp': Timestamp.now()}
    ];

    DocumentReference ref =
        await Firestore.instance.collection('chats').add(data);

    messages.forEach((data) {
      ref.collection('messages').add(data);
    });
  }

  List<Message> messages;
  String peerName;
  String peerAvatar;
}
