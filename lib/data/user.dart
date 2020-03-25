import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class User {
    /**
   * Returns the username to a given uid
   *
   * Returns null if no user is found or if there are 
   * multiple users with this uid.
   */
  static Future<String> userNameFromUid(String uid) async {
    QuerySnapshot possibleUsers = await Firestore.instance.collection('users').where('uid', isEqualTo: uid).getDocuments();
    try {
      return possibleUsers.documents.single.data['userName'];
    } on StateError catch (e) {
      print(e.message);
      return null;
    }
  }

  static Future<void> updateUser(String uid, {String name, String email}) async {
    try {
      QuerySnapshot possibleUsers = await Firestore.instance.collection('users').where('uid', isEqualTo: uid).getDocuments();
      
      DocumentReference user = possibleUsers.documents.single.reference;
      
      return await user.setData({'userName': name, 'email': email}, merge: true);
    } on PlatformException {
      rethrow;
    }
  }
}
