import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';


class FirebaseAuthModel extends Model{
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    
    Stream<FirebaseUser> get onAuthStateChanged => _firebaseAuth.onAuthStateChanged;
    
    Future<FirebaseUser> currentUser() async {
        return await _firebaseAuth.currentUser();
    }

    Future<void> signInWithGoogle() async {
        final GoogleSignIn _googleSignIn = GoogleSignIn();
        final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.getCredential(
            accessToken: googleAuth.idToken,
            idToken: googleAuth.accessToken, 
        );

        final FirebaseUser user = (await _firebaseAuth.signInWithCredential(credential)).user;
        print("singed in " + user.displayName);
        notifyListeners();
    }
}