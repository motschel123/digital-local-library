import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:digital_local_library/sign_in/user.dart';

class UserTokenInterface {
  static const FCM_TOKEN_FIELD = "fcmToken";

  static Future<void> updateFcmToken(
      {@required Future<CurrentUser> currentUser,
      @required Future<String> token}) async {
    Firestore _db = Firestore.instance;

    return currentUser.then((currentUser) {
      return _db.document('users/${currentUser.uid}/private/data').get();
    }).then((privateDataSnap) {
      return token.then((tokenValue) {
        if (tokenValue != privateDataSnap.data[FCM_TOKEN_FIELD]) {
          return privateDataSnap.reference
              .updateData({FCM_TOKEN_FIELD: tokenValue});
        }
        return null;
      });
    });
  }
}
