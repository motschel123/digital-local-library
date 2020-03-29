import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class BaseAuth {
  Stream<User> get onAuthStateChanged;
  Future<User> signInWithEmailAndPassword(
    String email,
    String password,
  );
  Future<User> createUserWithEmailAndPassword(String email, String password,
      {String name});

  Future<User> currentUser();
  Future<void> signOut();
  Future<User> signInWithGoogle();
  Future<User> signInAnonymously();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Stream<User> get onAuthStateChanged => _firebaseAuth.onAuthStateChanged.map(
        (FirebaseUser user) => User(fUser: user),
      );

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    try {
      // sign in with email and pass
      AuthResult authResult = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return User(
        fUser: authResult.user,
      );
    } catch (e) {
      throw AuthException.basic(e);
    }
  }

  @override
  Future<User> createUserWithEmailAndPassword(String email, String password,
      {String name}) async {
    try {
      // gets the currentUser to check if anonymously signed in
      FirebaseUser currentUser = await _firebaseAuth.currentUser();
      User resultUser;
      // if anonymously signed in
      if (currentUser != null && currentUser.isAnonymous) {
        // get email credential and link it to currently anonymous user
        AuthCredential credential =
            EmailAuthProvider.getCredential(email: email, password: password);
        AuthResult authResult =
            await currentUser.linkWithCredential(credential);
        resultUser = User(fUser: authResult.user);
      } else {
        // create a new user with email and password
        AuthResult authResult = await _firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password);
        resultUser = User(fUser: authResult.user);
      }
      // if a name is provided
      if (name != null && name.isNotEmpty) {
        // tell the 'new' user to update it's name
        await resultUser.update(displayName: name);
      }
      // return the 'new' user
      return resultUser;
    } on PlatformException catch (e) {
      switch (e.code) {
        default:
          throw AuthException(code: e.code, message: e.message);
      }
    } catch (e) {
      throw AuthException.basic(e);
    }
  }

  @override
  Future<User> currentUser() async {
    try {
      return User(fUser: await _firebaseAuth.currentUser());
    } catch (e) {
      throw AuthException.basic(e);
    }
  }

  @override
  Future<User> signInWithGoogle() async {
    try {
      final GoogleSignInAccount account = await _googleSignIn.signIn();
      if (account == null) {
        throw PlatformException(
          code: GoogleSignIn.kSignInCanceledError,
          message: "Google sign in canceled",
        );
      }

      final GoogleSignInAuthentication _auth = await account.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: _auth.idToken,
        accessToken: _auth.accessToken,
      );
      FirebaseUser currentUser = await _firebaseAuth.currentUser();
      User userResult;

      // if the current user is signed in anonymously
      if (currentUser != null && currentUser.isAnonymous) {
        // keep anonymoud user but link users google account to it
        AuthResult authResult =
            (await currentUser.linkWithCredential(credential));
        // update the auth user's email and username
        userResult = User(fUser: authResult.user);
        await userResult.update(
          email: authResult.additionalUserInfo.profile['email'],
          displayName: authResult.additionalUserInfo.profile['name'],
          photoUrl: authResult.additionalUserInfo.profile['photoUrl'],
        );
      } else {
        // sign the user in with its given google account
        AuthResult authResult =
            (await _firebaseAuth.signInWithCredential(credential));
        userResult = User(fUser: authResult.user);
      }
      return userResult;
    } on PlatformException catch (e) {
      throw AuthException(code: e.code, message: e.message);
    } catch (e) {
      throw AuthException.basic(e);
    }
  }

  @override
  Future<User> signInAnonymously() async {
    try {
      return User(fUser: (await _firebaseAuth.signInAnonymously()).user);
    } catch (e) {
      throw AuthException.basic(e);
    }
  }

  @override
  Future<void> signOut() {
    try {
      _googleSignIn.signOut();
      return FirebaseAuth.instance.signOut();
    } catch (e) {
      throw AuthException.basic(e);
    }
  }
}

class AuthException implements Exception {
  final String code;
  final String message;
  final String detail;

  AuthException({@required this.code, @required this.message, this.detail});

  static AuthException basic(dynamic e) {
    print("Error: $e");
    return AuthException(
        code: "BASIC_ERROR",
        message: "Oops, something went wrong.",
        detail: e.toString());
  }
}

abstract class BaseUser {
  String get displayName;
  String get email;
  String get uid;
  String get phoneNumber;
  String get photoUrl;

  bool get isAnonymous;
  bool get isEmailVerified;

  Future<void> update({String displayName, String email, String photoUrl});
}

class User implements BaseUser {
  String _displayName;
  String _email;
  String _uid;
  String _phoneNumber;
  String _photoUrl;

  bool _isAnonymous = true;
  bool _isEmailVerified = false;

  FirebaseUser _fUser;

  User({@required FirebaseUser fUser}) {
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
    
    await _syncChangesToDatabase(displayNameChanged: isDisplayName, emailChanged: isEmail, uidChanged: false, phoneNumberChanged: false, photoUrlChange: isPhotoUrl); 
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
    } catch (e) {

    }
    return false;
  }

  Future<bool> _updatePhotoUrl(String photoUrl) async {
    try {
      UserUpdateInfo updateInfo = UserUpdateInfo();
      updateInfo.photoUrl = photoUrl;
      await _fUser.updateProfile(updateInfo);
      _photoUrl = photoUrl;
      return true;
    } catch (e) {

    }
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

  String get displayName => _displayName;
  String get email => _email;
  String get uid => _uid;
  String get phoneNumber => _phoneNumber;
  String get photoUrl => _photoUrl;

  bool get isAnonymous => _isAnonymous;
  bool get isEmailVerified => _isEmailVerified;
}
