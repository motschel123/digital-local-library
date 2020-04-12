import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

abstract class User {
  String get displayName;
  String get email;
  String get uid;
  String get phoneNumber;
  String get photoUrl;

  bool get isAnonymous;
  bool get isEmailVerified;
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
    if(_documentId == null) {
      _documentId = (await Firestore.instance.collection('users').where('uid', isEqualTo: _uid).snapshots().single).documents.single.documentID;
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
}

class OtherUser extends User {
  String _displayName;
  String _email;
  String _phoneNumber;
  String _photoUrl;  
  String _uid;
  bool _isAnonymous;
  bool _isEmailVerified;

  /// The DocumentSnapshot must provide the following key:value pairs:
  /// 'displayName', 'email', 'uid'
  ///
  /// The following key:value pairs are optional and possible null
  /// 'photoUrl', 'phoneNumber', 'isAnonymous', 'isEmailVerified'
  OtherUser.fromDocumentSnapshot({@required DocumentSnapshot documentSnapshot})
      : assert(documentSnapshot != null),
        assert(documentSnapshot['displayName'] != null),
        assert(documentSnapshot['email'] != null),
        assert(documentSnapshot['uid'] != null) {
    this._displayName = documentSnapshot['displayName'];
    this._uid = documentSnapshot['uid'];
    this._email = documentSnapshot['email'];

    this._isAnonymous = documentSnapshot['isAnonymous'];
    this._isEmailVerified = documentSnapshot['isEmailVerified'];
    this._phoneNumber = documentSnapshot['phoneNumber'];
    this._photoUrl = documentSnapshot['photoUrl'];
  }

  @override
  String get displayName => _displayName;

  @override
  String get email => _email;

  @override
  bool get isAnonymous => _isAnonymous;

  @override
  bool get isEmailVerified => _isEmailVerified;

  @override
  String get phoneNumber => _phoneNumber;

  @override
  String get photoUrl => _photoUrl;

  @override
  String get uid => _uid;
}