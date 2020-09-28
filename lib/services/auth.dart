import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AppUser {
  AppUser({@required this.uid});
  final String uid;
}

abstract class AuthBase {
  Stream<AppUser> get onAuthStateChange;
  AppUser currentUser();
  Future<AppUser> signInAnonymously();
  Future<AppUser> signInWithGoogle();
  Future<void> signOut();
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  AppUser _userFromFirebase(User user) {
    if (user == null) return null;
    return AppUser(uid: user.uid);
  }

  @override
  Stream<AppUser> get onAuthStateChange {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  @override
  AppUser currentUser() {
    final user = _firebaseAuth.currentUser;
    return _userFromFirebase(user);
  }

  @override
  Future<AppUser> signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<AppUser> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final UserCredential authResult = await _firebaseAuth
            .signInWithCredential(GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ));
        return _userFromFirebase(authResult.user);
      } else {
        throw PlatformException(
          code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
          message: 'Missing Google Auth Token',
        );
      }
    } else {
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  @override
  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await _firebaseAuth.signOut();
  }
}
