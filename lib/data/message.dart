import 'package:digital_local_library/sqlite_db/message_database_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Message {
  String _text, _username;
  DateTime _dateTime;

  String get text => _text;
  String get username => _username;
  String get dateTimeString => DateFormat("yyyy-MM-dd HH:mm").format(_dateTime);
  DateTime get dateTime => _dateTime;

  Message(
      {@required String text,
      @required String username,
      @required DateTime dateTime})
      : assert(text != null),
        assert(username != null),
        assert(dateTime != null) {
    _text = text;
    _username = username;
    _dateTime = dateTime;
  }

  Message.fromMap(Map<String, dynamic> map) {
    _text = map[MessageDatabaseProvider.COLUMN_TEXT];
    _username = map[MessageDatabaseProvider.COLUMN_USERNAME];
    _dateTime = DateTime.parse(map[MessageDatabaseProvider.COLUMN_DATETIME]);
  }

  Map<String, dynamic> toMap() {
    return {
      'text': _text,
      'username': _username,
      'dateTime': dateTimeString,
    };
  }
}
