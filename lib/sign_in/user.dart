import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

abstract class User {
  static const String FIELD_DISPLAYNAME = 'displayName';
  static const String FIELD_PHOTOURL = 'photoUrl';

  String get displayName;
  String get photoUrl;

  Map<String, dynamic> toMap() {
    return {
      FIELD_DISPLAYNAME: displayName,
      FIELD_PHOTOURL: photoUrl,
    };
  }
}

class CurrentUser implements User {
  String _displayName;
  String _email;
  String _uid;
  String _phoneNumber;
  String _photoUrl;
  String _documentId;

  bool _isAnonymous = true;
  bool _isEmailVerified = false;

  FirebaseUser _fUser;

  CurrentUser.fromFirebaseUser({@required FirebaseUser fUser})
      : assert(fUser != null) {
    this._fUser = fUser;
    this._displayName = fUser.displayName;
    this._email = fUser.email;
    this._uid = fUser.uid;
    this._isAnonymous = fUser.isAnonymous;
    this._isEmailVerified = fUser.isEmailVerified;
    this._phoneNumber = fUser.phoneNumber;
    this._photoUrl = fUser.photoUrl;
  }

  Future<void> update(
      {String displayName, String email, String photoUrl}) async {
    bool isEmail = false, isDisplayName = false, isPhotoUrl = false;
    if (email != null && email.isNotEmpty) {
      isEmail = true;
    }
    if (displayName != null && displayName.isNotEmpty) {
      isDisplayName = true;
    }
    if (photoUrl != null && photoUrl.isNotEmpty) {
      isPhotoUrl = true;
    }

    if (isDisplayName) isDisplayName = await _updateDisplayName(displayName);
    if (isEmail) isEmail = await _updateEmail(email);
    if (isPhotoUrl) isPhotoUrl = await _updatePhotoUrl(photoUrl);

    await _syncChangesToDatabase(
        displayNameChanged: isDisplayName,
        emailChanged: isEmail,
        uidChanged: false,
        phoneNumberChanged: false,
        photoUrlChange: isPhotoUrl);
  }

  Future<bool> _updateEmail(String email) async {
    try {
      await _fUser.updateEmail(email);
      _email = email;
      return true;
    } on PlatformException catch (e) {
      developer.log(e.message, name: e.code, error: e);
    } catch (e) {
      developer.log("Couldn't update user email", error: e);
    }
    return false;
  }

  Future<bool> _updateDisplayName(String displayName) async {
    try {
      UserUpdateInfo updateInfo = UserUpdateInfo();
      updateInfo.displayName = displayName;
      await _fUser.updateProfile(updateInfo);
      _displayName = displayName;
      return true;
    } catch (e) {}
    return false;
  }

  Future<bool> _updatePhotoUrl(String photoUrl) async {
    try {
      UserUpdateInfo updateInfo = UserUpdateInfo();
      updateInfo.photoUrl = photoUrl;
      await _fUser.updateProfile(updateInfo);
      _photoUrl = photoUrl;
      return true;
    } catch (e) {}
    return false;
  }

  Future<void> _syncChangesToDatabase({
    @required bool displayNameChanged,
    @required bool emailChanged,
    @required bool uidChanged,
    @required bool phoneNumberChanged,
    @required bool photoUrlChange,
  }) async {
    WriteBatch writeBatch = Firestore.instance.batch();
    try {
      DocumentReference userRef = (await Firestore.instance
              .collection('users')
              .where('uid', isEqualTo: _uid)
              .getDocuments())
          .documents
          .single
          .reference;
      Map<String, String> changedData = {};
      if (displayNameChanged) changedData['displayName'] = _displayName;
      if (emailChanged) changedData['email'] = _email;
      if (uidChanged) changedData['uid'] = _uid;
      if (phoneNumberChanged) changedData['phoneNumber'] = _phoneNumber;
      if (photoUrlChange) changedData['photoUrl'] = _photoUrl;

      writeBatch.updateData(userRef, changedData);
      writeBatch.commit();
    } on StateError catch (e) {
      developer.log(e.message, error: e);
    }
    return null;
  }

  Future<String> get documentId async {
    if (_documentId == null) {
      _documentId = (await Firestore.instance
              .collection('users')
              .where('uid', isEqualTo: _uid)
              .snapshots()
              .single)
          .documents
          .single
          .documentID;
    }
    return _documentId;
  }

  String get displayName => _displayName;
  String get email => _email;
  String get uid => _uid;
  String get phoneNumber => _phoneNumber;
  String get photoUrl => _photoUrl;

  bool get isAnonymous => _isAnonymous;
  bool get isEmailVerified => _isEmailVerified;

  Map<String, dynamic> toMap() {
    return {
      User.FIELD_DISPLAYNAME: _displayName,
      User.FIELD_PHOTOURL: photoUrl,
    };
  }
}

class OtherUser extends User {
  String _displayName;
  String _photoUrl;

  /// The DocumentSnapshot must provide the following key:value pairs:
  /// 'displayName', 'email'
  ///
  /// The following key:value pairs are optional and possible null
  /// 'photoUrl', 'phoneNumber', 'isAnonymous', 'isEmailVerified'
  @override
  OtherUser.fromMap(Map<String, dynamic> map)
      : assert(map != null),
        assert(map[User.FIELD_DISPLAYNAME] != null)/*,
        assert(map[User.FIELD_PHOTOURL] != null)*/ {
    this._displayName = map[User.FIELD_DISPLAYNAME];
    this._photoUrl = map[User.FIELD_PHOTOURL];
  }

  Map<String, dynamic> toMap() {
    return {
      User.FIELD_DISPLAYNAME: _displayName,
      User.FIELD_PHOTOURL: _photoUrl,
    };
  }

  @override
  String get displayName => _displayName;

  @override
  String get photoUrl => _photoUrl;
}
