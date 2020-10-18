import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login/utils/firebase_auth_errors.dart';

enum VerificationState {
  Started,
  CodeSent,
  CodeResent,
  VerifiedNewUser,
  Verified,
  Failed,
  Error,
  AutoRetrievalTimeOut,
  UserCanceled,
  Init,
  SocialDataVerified
}

class PhoneAuthState {
  final VerificationState state;
  final String phone;
  final String verificationId;
  final String message;
  PhoneAuthState({this.state, this.message, this.phone, this.verificationId});
}

class EmailService {
  final auth = FirebaseAuth.instance;

  EmailService();

  Stream<User> get authChanges => auth.authStateChanges();
  Stream<User> get userChanges => auth.userChanges();
  User get currentUser => auth.currentUser;

  Future<User> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      final frontError = FireBaseAuthError.errorHandled(e.code);
      print(frontError);
      throw FirebaseAuthException(message: frontError);
    } catch (e) {
      print(e);
      throw FirebaseAuthException(message: FireBaseAuthError.kGeneralError);
    }
  }

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      final frontError = FireBaseAuthError.errorHandled(e.code);
      print(frontError);
      throw FirebaseAuthException(message: frontError);
    } catch (e) {
      print(e);
      throw FirebaseAuthException(message: FireBaseAuthError.kGeneralError);
    }
  }

  Future<void> signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      throw (e.code);
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      final frontError = FireBaseAuthError.errorHandled(e.code);
      print(frontError);
      throw FirebaseAuthException(message: frontError);
    } catch (e) {
      print(e);
      throw FirebaseAuthException(message: FireBaseAuthError.kGeneralError);
    }
  }

  Future<void> updateProfile(String name, String photoUrl) async {
    try {
      currentUser.updateProfile(displayName: name, photoURL: photoUrl);
    } on FirebaseAuthException catch (e) {
      final frontError = FireBaseAuthError.errorHandled(e.code);
      print(frontError);
      throw FirebaseAuthException(message: frontError);
    } catch (e) {
      print(e);
      throw FirebaseAuthException(message: FireBaseAuthError.kGeneralError);
    }
  }
}
