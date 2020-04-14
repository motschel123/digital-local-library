import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Message {
  final String text, username;
  final DateTime dateTime;
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

  Message({@required this.text, @required this.username, @required this.dateTime});

  
}