import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  static Future<String> nickNameFromUid(String uid) async {
    Future<QuerySnapshot> possibleUsers = Firestore.instance.collection('users').where('uid', isEqualTo: uid).getDocuments();

    DocumentSnapshot firstUser = (await possibleUsers).documents.firstWhere((user) => user.data['uid'].toString() == uid);

    return firstUser.data['userName'];
  }
}
