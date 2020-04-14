import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Message {
  final String text, username;
  final DateTime dateTime;
  

  Message({@required this.text, @required this.username, @required this.dateTime});

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'username': username,
      'dateTime': dateTime.toIso8601String(),
    };
  }
}

class Exaple {
  static List<Message> test = <Message>[
    Message(text: "Hey Marcel", username: "Pia", dateTime: Timestamp.now().toDate().subtract(Duration(minutes: 10))),
    Message(text: "Hey Pia", username: "Marcel", dateTime: Timestamp.now().toDate()),
    Message(text: "Hey Marcel", username: "Pia", dateTime: Timestamp.now().toDate()),
    Message(text: "Hey Pia", username: "Marcel", dateTime: Timestamp.now().toDate()),
    Message(text: "Hey Marcel", username: "Pia", dateTime: Timestamp.now().toDate()),
    Message(text: "Hey Pia", username: "Marcel", dateTime: Timestamp.now().toDate()),
    Message(text: "Hey Marcel", username: "Pia", dateTime: Timestamp.now().toDate()),
    Message(text: "Hey Pia", username: "Marcel", dateTime: Timestamp.now().toDate()),
  ];
}