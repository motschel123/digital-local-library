import 'package:digital_local_library/sign_in/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

export 'package:digital_local_library/sign_in/user.dart';


abstract class BaseAuth {
  Stream<CurrentUser> get onAuthStateChanged;
  Future<CurrentUser> signInWithEmailAndPassword(
    String email,
    String password,
  );
  Future<CurrentUser> createUserWithEmailAndPassword(String email, String password,
      {String name});

  Future<CurrentUser> currentUser();
  Future<void> signOut();
  Future<CurrentUser> signInWithGoogle();
  Future<CurrentUser> signInAnonymously();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Stream<CurrentUser> get onAuthStateChanged => _firebaseAuth.onAuthStateChanged.map(
        (FirebaseUser user) => CurrentUser.fromFirebaseUser(fUser: user),
      );

  @override
  Future<CurrentUser> signInWithEmailAndPassword(String email, String password) async {
    try {
      // sign in with email and pass
      AuthResult authResult = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return CurrentUser.fromFirebaseUser(
        fUser: authResult.user,
      );
    } catch (e) {
      throw AuthException.basic(e);
    }
  }

  @override
  Future<CurrentUser> createUserWithEmailAndPassword(String email, String password,
      {String name}) async {
    try {
      // gets the currentUser to check if anonymously signed in
      FirebaseUser currentUser = await _firebaseAuth.currentUser();
      CurrentUser resultUser;
      // if anonymously signed in
      if (currentUser != null && currentUser.isAnonymous) {
        // get email credential and link it to currently anonymous user
        AuthCredential credential =
            EmailAuthProvider.getCredential(email: email, password: password);
        AuthResult authResult =
            await currentUser.linkWithCredential(credential);
        resultUser = CurrentUser.fromFirebaseUser(fUser: authResult.user);
      } else {
        // create a new user with email and password
        AuthResult authResult = await _firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password);
        resultUser = CurrentUser.fromFirebaseUser(fUser: authResult.user);
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
  Future<CurrentUser> currentUser() async {
    try {
      return CurrentUser.fromFirebaseUser(fUser: await _firebaseAuth.currentUser());
    } catch (e) {
      throw AuthException.basic(e);
    }
  }

  /// Signs the user into firebaseAuth with a google account and
  /// creates a new firebaseAuth-User if not signed in previousely
  /// 
  /// If the current user was previously signed in anonymously it 
  /// links the google credential to the existing user and updates
  /// the existing user (email, name, photoUrl) to match the 
  /// provided data (also syncs with firestore)
  @override
  Future<CurrentUser> signInWithGoogle() async {
    try {
      // receives the google account to sign in with
      final GoogleSignInAccount account = await _googleSignIn.signIn();
      if (account == null) {
        // signals the user has cancled google sign in
        throw PlatformException(
          code: GoogleSignIn.kSignInCanceledError,
          message: "Google sign in canceled",
        );
      }
      // get needed credential
      final GoogleSignInAuthentication _auth = await account.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: _auth.idToken,
        accessToken: _auth.accessToken,
      );
      // get current user to check if previously signed in anonymously
      FirebaseUser currentUser = await _firebaseAuth.currentUser();
      CurrentUser userResult;

      // if the current user is signed in anonymously
      if (currentUser != null && currentUser.isAnonymous) {
        // keep anonymoud user but link users google account to it
        AuthResult authResult =
            (await currentUser.linkWithCredential(credential));
        // update the auth user's email and username
        userResult = CurrentUser.fromFirebaseUser(fUser: authResult.user);
        await userResult.update(
          email: authResult.additionalUserInfo.profile['email'],
          displayName: authResult.additionalUserInfo.profile['name'],
          photoUrl: authResult.additionalUserInfo.profile['photoUrl'],
        );
      } else {
        // sign the user in with its given google account
        AuthResult authResult =
            (await _firebaseAuth.signInWithCredential(credential));
        userResult = CurrentUser.fromFirebaseUser(fUser: authResult.user);
      }
      return userResult;
    } on PlatformException catch (e) {
      throw AuthException(code: e.code, message: e.message);
    } catch (e) {
      throw AuthException.basic(e);
    }
  }

  @override
  Future<CurrentUser> signInAnonymously() async {
    try {
      return CurrentUser.fromFirebaseUser(fUser: (await _firebaseAuth.signInAnonymously()).user);
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
