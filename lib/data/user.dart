import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_local_library/sign_in/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class User {
  final String userName;
  final String uid;
  final String email;

  final DocumentSnapshot userSnapshot;

  User({@required this.userName, @required this.uid, @required this.email, @required this.userSnapshot});

 /**
  * Returns a User object to a given uid
  *
  * Returns null if no user is found or if there are 
  * multiple users with this uid.
  */
  static Future<User> fromUid(String uid) async {
    QuerySnapshot possibleUsers = await Firestore.instance.collection('users').where('uid', isEqualTo: uid).getDocuments();
    try {
      DocumentSnapshot user = possibleUsers.documents.single;
      return User(userName: user.data['userName'], uid: user.data['uid'], email: user.data['email'], userSnapshot: user);
    } on StateError catch (e) {
      print(e.message);
      return null;
    }
  }

  static Future<User> fromContext(BuildContext context) async {
    return fromUid(await AuthProvider.of(context).currentUser());
  }

  Future<void> updateUser({String name, String email}) async {
    try {
      await userSnapshot.reference.setData({'userName': name, 'email': email}, merge: true);
    } on PlatformException {
      rethrow;
    }
  }
}
