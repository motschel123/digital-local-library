import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  Future<String> currentUser();
  Future<void> signOut();
  Future<String> signInWithGoogle();
  Future<String> signInAnonymously();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Stream<String> get onAuthStateChanged => _firebaseAuth.onAuthStateChanged.map(
        (FirebaseUser user) => user?.uid,
  );

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
  Future<String> createUserWithEmailAndPassword(
      String email, String password) async {
        try {
    return (await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user
        .uid;
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
  Future<String> currentUser() async {
    try {
      return (await _firebaseAuth.currentUser()).uid;
    } catch (e) {
      throw AuthException.basic(e);
    }
  }
  
  @override
  Future<String> signInWithGoogle() async {
    try {
      final GoogleSignInAccount account = await _googleSignIn.signIn();
      if(account == null) throw PlatformException(code: GoogleSignIn.kSignInCanceledError, message: "Google sign in canceled");
      final GoogleSignInAuthentication _auth = await account.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: _auth.idToken,
        accessToken: _auth.accessToken,
      );
      FirebaseUser currentUser = await _firebaseAuth.currentUser();
      AuthResult authResult;
      if(currentUser != null && currentUser.isAnonymous) {
        authResult = (await currentUser.linkWithCredential(credential));
      } else {
        authResult = (await _firebaseAuth.signInWithCredential(credential));
      }
      return authResult.user.uid;
    } on PlatformException catch (e) {
      throw AuthException(code: e.code, message: e.message);
    } catch (e) {
      throw AuthException.basic(e);
    }
  }

  @override
  Future<String> signInAnonymously() async {
    try {
      return (await _firebaseAuth.signInAnonymously()).user.uid;
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
    return AuthException(code: "BASIC_ERROR", message: "Oops, something went wrong.", detail: e.toString());
  }
}

