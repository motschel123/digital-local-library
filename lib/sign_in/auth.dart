import 'package:firebase_auth/firebase_auth.dart';
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
    return (await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user
        .uid;
  }

  @override
  Future<FirebaseUser> currentUser() async {
    return await _firebaseAuth.currentUser();
  }

  @override
  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    return (await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password))
        .user
        .uid;
  }

  @override
  Future<AuthResult> signInWithGoogle() async {
    final GoogleSignInAccount account = await _googleSignIn.signIn();
    if(account == null) throw PlatformException(code: GoogleSignIn.kSignInFailedError, message: "Signing in with google failed");
    final GoogleSignInAuthentication _auth = await account.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: _auth.idToken,
      accessToken: _auth.accessToken,
    );
    return await _firebaseAuth.signInWithCredential(credential);
  }

  @override
  Future<AuthResult> signInAnonymously() async {
    return await _firebaseAuth.signInAnonymously();
  }

  @override
  Future<void> signOut() {
    _googleSignIn.signOut();
    return FirebaseAuth.instance.signOut();
  }
}
