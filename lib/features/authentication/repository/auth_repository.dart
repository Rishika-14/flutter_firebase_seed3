import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'base_auth_repository.dart';

class AuthRepository extends BaseAuthRepository {
  late final auth.FirebaseAuth _firebaseAuth;

  AuthRepository() {
    _firebaseAuth = auth.FirebaseAuth.instance;
  }

  @override
  Future<auth.User?> googleSignIn() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();

      if(googleSignInAccount == null) {
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleSignInAccount!.authentication;

      // Create a new credential
      final credential = auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      auth.UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      return userCredential.user;
    } on auth.FirebaseAuthException catch (err) {
      throw 'firebase-auth-exception';
    } on PlatformException catch (err) {
      print('Platform exception error '
          '----------------------------------------------------->');
      print('err.code ------>');
      print(err.code);
      print('err.message ------>');
      print(err.message);
      print('err.details ------>');
      print(err.details);
      print('err.stacktrace ------>');
      print(err.stacktrace);
      throw 'platform-exception';
    }
  }

  @override
  Future<void> logout() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await _firebaseAuth.signOut();
    } catch (e) {
      print('Error Sign Out');
    }
  }

  @override
  Stream<auth.User?> get user => _firebaseAuth.userChanges();
}
