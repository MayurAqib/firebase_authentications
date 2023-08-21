import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:learning_phone_authentication/pages/home_page.dart';
import 'package:learning_phone_authentication/pages/verify_otp.dart';

class AuthProvider extends ChangeNotifier {
  //! Firebase Login with Phone Number and its ocmes with two parts (1st- send otp and 2nd verify otp)

  //todo: sending otp
  void phoneAuthentication(BuildContext context, String phoneNumber) async {
    if (phoneNumber.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Enter valid mobile number')));
      return;
    }
    FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91$phoneNumber',
        verificationCompleted: (_) {},
        verificationFailed: (e) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.toString())));
        },
        codeSent: (String verificationId, int? token) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VerifyOtp(
                        verificationId: verificationId,
                      )));
        },
        codeAutoRetrievalTimeout: (e) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.toString())));
        });
  }

  //todo: Verify Otp and login
  void verifyOtp(
      BuildContext context, String verificationId, String otpController) async {
    final credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otpController);
    try {
      showDialog(
          context: context,
          builder: (context) => const Center(
                child: CircularProgressIndicator(color: Colors.amber),
              ));
      await FirebaseAuth.instance.signInWithCredential(credential);
      if (context.mounted) {
        Navigator.pop(context);
      }
      if (context.mounted) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      }

      print('signin successful');
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
    }
  }

  //!  google sign in
  signInWithGoogle(BuildContext context) async {
    try {
      showDialog(
          context: context,
          builder: (context) => const Center(
                child: CircularProgressIndicator(),
              ));
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication gAuth = await gUser!.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: gAuth.accessToken, idToken: gAuth.idToken);
      if (context.mounted) {
        Navigator.pop(context);
      }
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
    }
  }

  //! facebook sign in

  signInWithFacebook(BuildContext context) async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
    }
  }
}
