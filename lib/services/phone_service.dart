import 'package:firebase_auth/firebase_auth.dart';

class PhoneService {
  final FirebaseAuth auth;

  PhoneService(this.auth);
  verifyPhoneNumber(
    String phone,
    Function verificationCompleted,
    Function verificationFailed,
    Function codeSent,
    Function codeAutoRetrievalTimeout,
  ) {
    print(phone);

    auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }
}
