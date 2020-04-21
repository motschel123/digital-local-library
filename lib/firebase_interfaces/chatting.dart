import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_local_library/data/chat.dart';
import 'package:digital_local_library/data/message.dart';
import 'package:digital_local_library/firebase_interfaces/users.dart';
import 'package:digital_local_library/sign_in/user.dart';
import 'package:flutter/material.dart';

class ChattingInterface {
  final Future<CurrentUser> currentUser;

  static Stream<List<Message>> getMessages(Chat chat) {
    return Firestore.instance
        .collection('chats/${chat.chatDocumentId}/messages')
        .snapshots()
        .map<List<Message>>((querySnap) {
      List<Message> messages = <Message>[];
      querySnap.documents.forEach((docSnap) {
        messages.add(Message.fromMap(docSnap.data));
      });
      return messages;
    });
  }

  static Future<DocumentReference> newMessage(Chat chat,
      {@required Message message}) {
    return Firestore.instance
        .collection('chats/${chat.chatDocumentId}/messages')
        .add(message.toMap());
  }

  Future<Stream<List<Chat>>> get getActiveChats {
    return currentUser.then<Stream<List<Chat>>>((currentUser) {
      return Firestore.instance
          .collection('users/${currentUser.uid}/private/data/userChats')
          .snapshots()
          .map<List<Chat>>((querySnap) {
        List<Chat> chatsList = [];
        querySnap.documents.forEach((docSnap) {
          chatsList
              .add(Chat.fromMap(docSnap.data, peerUid: docSnap.documentID));
        });
        return chatsList;
      });
    });
  }

  ChattingInterface({@required this.currentUser});

  Future<Chat> getChatWith(String peerUid) {
    return currentUser.then<DocumentSnapshot>((cUser) {
      return Firestore.instance
          .document('users/${cUser.uid}/private/data/userChats/$peerUid')
          .get();
    }).then<Chat>((docSnap) {
      if (docSnap == null || !docSnap.exists) {
        return newChat(peerUid: peerUid);
      } else {
        String chatDocumentId = docSnap.data['chatDocumentId'];
        return Firestore.instance
            .document('chats/$chatDocumentId')
            .get()
            .then<Chat>((chatDocSnap) {
          return Chat(
            peerUid: docSnap.documentID,
            peerName: docSnap.data['peerName'],
            peerAvatarURL: docSnap.data['peerAvatarURL'],
            chatDocumentId: chatDocSnap.documentID,
          );
        });
      }
    });
  }

  Future<Chat> newChat({@required String peerUid}) {
    return currentUser.then<DocumentReference>((cUser) async {
      return await Firestore.instance.collection('chats').add({
        'peers': [
          cUser.uid,
          peerUid,
        ]
      });
    }).then<Chat>((docRef) {
      return UsersInterface.getOtherUser(peerUid).then<Chat>((otherUser) {
        return Chat(
          peerUid: otherUser.uid,
          peerName: otherUser.displayName,
          peerAvatarURL: otherUser.photoURL,
          chatDocumentId: docRef.documentID,
        );
      });
    });
  }
}
