import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthException implements Exception {
  final String code;
  final String message;
  final String detail;

  AuthException({@required this.code, @required this.message, this.detail});

  static AuthException basic(dynamic e) {
    return AuthException(code: "BASIC_ERROR", message: "Oops, something went wrong.", detail: e.toString());
  }
}

abstract class BaseAuth {
  Stream<String> get onAuthStateChanged;
  Future<String> signInWithEmailAndPassword(
    String email,
    String password,
  );
  Future<String> createUserWithEmailAndPassword(
    String email,
    String password,
  );

  Future<FirebaseUser> currentUser();
  Future<void> signOut();
  Future<AuthResult> signInWithGoogle();
  Future<AuthResult> signInAnonymously();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Stream<String> get onAuthStateChanged => _firebaseAuth.onAuthStateChanged.map(
        (FirebaseUser user) => user?.uid,
      );

  @override
  Future<String> createUserWithEmailAndPassword(
      String email, String password) async {
        try {
    return (await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user
        .uid;
        } catch (e) {
          throw AuthException.basic(e);
        }
  }

  @override
  Future<FirebaseUser> currentUser() async {
    try {
      return await _firebaseAuth.currentUser();
    } catch (e) {
      throw AuthException.basic(e);
    }
  }

  @override
  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
        try {
      return (await _firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user
          .uid;
        } catch (e) {
          throw AuthException.basic(e);
        }
  }

  @override
  Future<AuthResult> signInWithGoogle() async {
    try {
      final GoogleSignInAccount account = await _googleSignIn.signIn();
      if(account == null) throw PlatformException(code: GoogleSignIn.kSignInFailedError, message: "Signing in with google failed");
      final GoogleSignInAuthentication _auth = await account.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: _auth.idToken,
        accessToken: _auth.accessToken,
      );
      return await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      throw AuthException.basic(e);
    }
  }

  @override
  Future<AuthResult> signInAnonymously() async {
    try {
      return await _firebaseAuth.signInAnonymously();
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
