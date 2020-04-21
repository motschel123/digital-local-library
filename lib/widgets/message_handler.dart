import 'package:digital_local_library/firebase_interfaces/user_token.dart';
import 'package:digital_local_library/sign_in/auth_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// TODO: Add message handler to widget tree and provide a child

class MessageHandler extends StatefulWidget {
  final Widget child;

  MessageHandler({this.child});

  @override
  State<StatefulWidget> createState() {
    return _MessageHandlerState();
  }
}

class _MessageHandlerState extends State<MessageHandler> {
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    _fcm.requestNotificationPermissions();
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        final snackbar = SnackBar(
          content: Text(message['notification']['title']),
        );
        showDialog(
          context: context,
          builder: (context) => AlertDialog(),
        );
        Scaffold.of(context).showSnackBar(snackbar);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
    );
  }

  @override
  void didChangeDependencies() {
    UserTokenInterface.updateFcmToken(currentUser: AuthProvider.of(context).currentUser(), token: _fcm.getToken());
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
