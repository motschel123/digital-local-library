import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Message {
  final String text, username;
  final Timestamp timestamp;

  Message({@required this.text, @required this.username, @required this.timestamp});
}