import 'package:digital_local_library/data/message.dart';
import 'package:digital_local_library/firebase_interfaces/chatting.dart';
import 'package:digital_local_library/screens/chats/chat_screen.dart';
import 'package:digital_local_library/sqlite_db/chat_database_provider.dart';
import 'package:flutter/material.dart';

class BaseChat {
  String peerUid;
  String peerName;
  String peerAvatarUrl;

  BaseChat({
    @required this.peerUid,
    @required this.peerName,
    @required this.peerAvatarUrl,
  });

  BaseChat.fromMap(map, {@required this.peerUid}) {
    peerName = map[ChatDatabaseProvider.COLUMN_PEERNAME];
    peerAvatarUrl = map[ChatDatabaseProvider.COLUMN_PEER_AVATAR_URL];
  }

  Map<String, dynamic> toMap() {
    return {
      ChatDatabaseProvider.COLUMN_PEERNAME: peerName,
      ChatDatabaseProvider.COLUMN_PEER_AVATAR_URL: peerAvatarUrl,
    };
  }
}

class Chat extends BaseChat {
  String chatDocumentId;
  String peerUid;
  String peerName;
  String peerAvatarURL;

  Stream<List<Message>> get messageStream =>
      ChattingInterface.getMessages(this);

  Chat({
    @required this.chatDocumentId,
    @required this.peerUid,
    @required this.peerName,
    @required this.peerAvatarURL,
  }) : assert(chatDocumentId != null);

  Future<void> newMessage(Message message) {
    return ChattingInterface.newMessage(this, message: message);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      ChatDatabaseProvider.COLUMN_CHAT_DOCUMENT_ID: chatDocumentId,
      ChatDatabaseProvider.COLUMN_PEERNAME: peerName,
      ChatDatabaseProvider.COLUMN_PEER_AVATAR_URL: peerAvatarURL,
    };
    return map;
  }

  Chat.fromMap(Map<String, dynamic> map, {@required this.peerUid})
      : assert(map[ChatDatabaseProvider.COLUMN_CHAT_DOCUMENT_ID] != null) {
    chatDocumentId = map[ChatDatabaseProvider.COLUMN_CHAT_DOCUMENT_ID];
    peerName = map[ChatDatabaseProvider.COLUMN_PEERNAME];
    peerAvatarURL = map[ChatDatabaseProvider.COLUMN_PEER_AVATAR_URL];
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
