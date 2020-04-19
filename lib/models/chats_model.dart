import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_local_library/data/chat.dart';
import 'package:digital_local_library/firebase_interfaces/chats.dart';
import 'package:digital_local_library/sign_in/auth.dart';
import 'package:digital_local_library/sign_in/user.dart';
import 'package:digital_local_library/sqlite_db/chat_database_provider.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ChatsModel extends Model {
  final Future<CurrentUser> currentUser;
  ChatsInterface _chatsInterface;

  List<Chat> _chats = [];
  List<Chat> get chats => _chats;

  ChatsModel({@required this.currentUser}) {
    _chatsInterface = ChatsInterface(currentUser: currentUser);
    _chatsInterface.getChats.then((Stream<List<Chat>> chatsListStream) {
      chatsListStream.listen((chatsList) {
        _chats = chatsList;
        notifyListeners();
      });
    });
  }
}
