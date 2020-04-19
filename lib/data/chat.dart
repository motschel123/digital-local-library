import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_local_library/data/message.dart';
import 'package:digital_local_library/screens/chats/chat_screen.dart';
import 'package:digital_local_library/sqlite_db/chat_database_provider.dart';
import 'package:flutter/material.dart';

class Chat {
  /// Supposed to be the document id of the
  /// chat document in firestore '/chats'
  int dbId;
  String chatDocumentId;
  String peerUid;
  String peerName;
  String peerAvatarURL;
  List<Message> messages;

  Chat(
      {this.dbId,
      this.chatDocumentId,
      @required this.peerUid,
      @required this.peerName,
      @required this.peerAvatarURL,
      this.messages = const <Message>[]});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      ChatDatabaseProvider.COLUMN_CHAT_DOCUMENT_ID: chatDocumentId,
      ChatDatabaseProvider.COLUMN_PEERNAME: peerName,
      ChatDatabaseProvider.COLUMN_PEER_AVATAR_URL: peerAvatarURL,
      ChatDatabaseProvider.COLUMN_MESSAGES: messages,
    };
    if (dbId != null) {
      map[ChatDatabaseProvider.COLUMN_DATABASE_ID] = dbId;
    }
    return map;
  }

  Chat.fromMap(Map<String, dynamic> map, {@required this.peerUid}) {
    dbId = map[ChatDatabaseProvider.COLUMN_DATABASE_ID];
    chatDocumentId = map[ChatDatabaseProvider.COLUMN_CHAT_DOCUMENT_ID];
    peerName = map[ChatDatabaseProvider.COLUMN_PEERNAME];
    peerAvatarURL = map[ChatDatabaseProvider.COLUMN_PEER_AVATAR_URL];
    messages = [];
  }

  Future<T> pushChatScreen<T extends Object>(BuildContext context) {
    if (chatDocumentId != null) {
      return Navigator.of(context).push<T>(
        MaterialPageRoute(
          builder: (context) => ChatScreen(chat: this),
        ),
      );
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Something went wrong"),
        ),
      );
    }
    return Future.value();
  }
}
