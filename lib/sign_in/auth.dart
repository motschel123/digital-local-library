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
  Future<User> createUserWithEmailAndPassword(
    String email,
    String password,
  );

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
  Future<User> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      return User(fUser: (await _firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password)).user);
    } catch (e) {
      throw AuthException.basic(e);
    }
  }

  @override
  Future<User> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      return User(fUser: (await _firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password)).user);
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
      if (account == null)
        throw PlatformException(
            code: GoogleSignIn.kSignInCanceledError,
            message: "Google sign in canceled");
      final GoogleSignInAuthentication _auth = await account.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: _auth.idToken,
        accessToken: _auth.accessToken,
      );
      FirebaseUser currentUser = await _firebaseAuth.currentUser();
      AuthResult authResult;
      if (currentUser != null && currentUser.isAnonymous) {
        authResult = (await currentUser.linkWithCredential(credential));
      } else {
        authResult = (await _firebaseAuth.signInWithCredential(credential));
      }
      return User(fUser: authResult.user);
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

class User {
  String _displayName;
  String _email;
  String _uid;
  String _phoneNumber;
  String _photoUrl;

  bool _isAnonymous = true;
  bool _isEmailVerified = false;

  User({@required FirebaseUser fUser}) {
    this._displayName = fUser.displayName;
    this._email = fUser.email;
    this._uid = fUser.uid;
    this._isAnonymous = fUser.isAnonymous;
    this._isEmailVerified = fUser.isEmailVerified;
    this._phoneNumber = fUser.phoneNumber;
    this._photoUrl = fUser.photoUrl;
  }

  Future<void> updateUser({String name, String email}) async {}

  String get displayName => _displayName;
  String get email => _email;
  String get uid => _uid;
  String get phoneNumber => _phoneNumber;
  String get photoUrl => _photoUrl;
  
  bool get isAnonymous => _isAnonymous;
  bool get isEmailVerified => _isEmailVerified;
}
