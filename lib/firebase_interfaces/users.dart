import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_local_library/sign_in/user.dart';

class UsersInterface {
  static Future<OtherUser> getOtherUser(String uid) {
    return Firestore.instance.document('users/$uid').get().then((docSnap) {
      return OtherUser.fromMap(docSnap.data, uid: uid);
    });
  }
}
