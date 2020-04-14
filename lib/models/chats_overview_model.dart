import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_local_library/data/chat.dart';
import 'package:digital_local_library/sign_in/auth.dart';
import 'package:digital_local_library/sign_in/user.dart';
import 'package:digital_local_library/sqlite_db/chat_database_provider.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ChatsOverviewModel extends Model {
  final Future<CurrentUser> currentUser;

  List<Chat> _chats;
  List<Chat> get chats => _chats;

  ChatsOverviewModel({@required this.currentUser}) {
    currentUser.then((currentUser) {
      Firestore.instance.collection('users').document(currentUser.uid).collection('chats').snapshots().map((querySnap) {
        List<Chat> chatsList = <Chat>[];
        querySnap.documents.forEach((docSnap) {
          if(docSnap.exists){
            chatsList.add(Chat.fromMap({
            ChatDatabaseProvider.COLUMN_ID: docSnap.data['chatReference'],
            ChatDatabaseProvider.COLUMN_PEERNAME: docSnap.data['peerName'],
            ChatDatabaseProvider.COLUMN_PEER_AVATAR_URL: docSnap.data['peerAvatarURL'],
          }));
          }
        });
        return chatsList;
      }).listen((chatsList) {
        _chats = chatsList;
        notifyListeners();
      });
    }); 
  }
}
