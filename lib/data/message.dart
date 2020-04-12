import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Message {
  final String message, user;
  final Timestamp timestamp;

  Message({@required this.message, @required this.user, @required this.timestamp});
}