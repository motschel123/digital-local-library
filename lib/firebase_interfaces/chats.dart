import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_local_library/data/chat.dart';
import 'package:digital_local_library/sign_in/user.dart';
import 'package:flutter/material.dart';

class ChatsInterface {
  final Future<CurrentUser> currentUser;

  Future<Stream<List<Chat>>> get getChats async {
    return currentUser.then<Stream<List<Chat>>>((currentUser) {
      return Firestore.instance
          .collection('users/${currentUser.uid}/private/data/userChats')
          .snapshots()
          .map<List<Chat>>((querySnap) {
        List<Chat> chatsList = [];
        querySnap.documents.forEach((docSnap) {
          chatsList.add(Chat.fromMap(docSnap.data, peerUid: docSnap.documentID));
        });
        return chatsList;
      });
    });
  }

  ChatsInterface({@required this.currentUser});
}
