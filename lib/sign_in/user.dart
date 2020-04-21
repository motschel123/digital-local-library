import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

abstract class User {
  static const String FIELD_DISPLAYNAME = 'displayName';
  static const String FIELD_PHOTOURL = 'photoURL';
  static const String FIELD_UID = 'uid';

  String get displayName;
  String get photoURL;
  String get uid;

  Map<String, dynamic> toMap() {
    return {
      FIELD_DISPLAYNAME: displayName,
      FIELD_PHOTOURL: photoURL,
      FIELD_UID: uid,
    };
  }
}

class CurrentUser implements User {
  String _displayName;
  String _email;
  String _uid;
  String _phoneNumber;
  String _photoURL;

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
    this._photoURL = fUser.photoUrl;
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
      _photoURL = photoUrl;
      return true;
    } catch (e) {}
    return false;
  }

  Future<void> _syncChangesToDatabase({
    @required bool displayNameChanged,
    @required bool emailChanged,
    @required bool phoneNumberChanged,
    @required bool photoUrlChange,
  }) async {
    WriteBatch writeBatch = Firestore.instance.batch();
    try {
      DocumentReference publicRef = Firestore.instance.document('users/$_uid');
      DocumentReference privateRef =
          Firestore.instance.document('users/$_uid/private/data');
      Map<String, String> changedPrivateData = {};
      Map<String, String> changedPublicData = {};
      if (displayNameChanged) changedPublicData['displayName'] = _displayName;
      if (photoUrlChange) changedPublicData['photoUrl'] = _photoURL;

      if (emailChanged) changedPrivateData['email'] = _email;
      if (phoneNumberChanged) changedPrivateData['phoneNumber'] = _phoneNumber;

      writeBatch.updateData(publicRef, changedPublicData);
      writeBatch.updateData(privateRef, changedPrivateData);
      writeBatch.commit();
    } on StateError catch (e) {
      developer.log(e.message, error: e);
    }
    return null;
  }

  String get displayName => _displayName;
  String get email => _email;
  String get uid => _uid;
  String get phoneNumber => _phoneNumber;
  String get photoURL => _photoURL;

  bool get isAnonymous => _isAnonymous;
  bool get isEmailVerified => _isEmailVerified;

  Map<String, dynamic> toMap() {
    return {
      User.FIELD_UID: _uid,
      User.FIELD_DISPLAYNAME: _displayName,
      User.FIELD_PHOTOURL: photoURL,
    };
  }
}

class OtherUser extends User {
  String _displayName;
  String _photoURL;
  String _uid;

  /// The DocumentSnapshot must provide the following key:value pairs:
  /// 'displayName', 'email'
  ///
  /// The following key:value pairs are optional and possible null
  /// 'photoUrl', 'phoneNumber', 'isAnonymous', 'isEmailVerified'
  @override
  OtherUser.fromMap(Map<String, dynamic> map, {String uid}) 
      : assert(map != null),
        assert(map[User.FIELD_UID] != null || uid != null),
        assert(map[User.FIELD_DISPLAYNAME] != null){
    this._uid = uid != null ? uid : map[User.FIELD_UID] ;
    this._displayName = map[User.FIELD_DISPLAYNAME];
    this._photoURL = map[User.FIELD_PHOTOURL];
  }

  Map<String, dynamic> toMap() {
    return {
      User.FIELD_UID: _uid,
      User.FIELD_DISPLAYNAME: _displayName,
      User.FIELD_PHOTOURL: _photoURL,
    };
  }

  @override
  String get displayName => _displayName;

  @override
  String get photoURL => _photoURL;

  @override
  String get uid => _uid;
}
