// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../utils/custom_text.dart';

class Authentication {
  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    const String accountExisted = "account-exists-with-different-credential";
    const String crendentialInvalid = "invalid-credential";

    FirebaseAuth auth = FirebaseAuth.instance;

    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken);

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);
        user = userCredential.user;
        // print("Google Sign in: " + user.toString());

        /* Navigator.of(context).pushReplacement(PageTransition(
            child: TeamCheckScreen(),
            type: PageTransitionType.rightToLeft,
            duration: Duration(milliseconds: 800))); */
      } on FirebaseAuthException catch (e) {
        if (e.code == accountExisted) {
          //handle the error here
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: CustomText(
            text:
                "The account is already exists with a differrent crendential.",
          )));
        } else if (e.code == crendentialInvalid) {
          //handle the error here
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: CustomText(
            text: "Error occured while accesing credentials. Try again!",
          )));
        }
      } catch (e) {
        //handle the error here
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: CustomText(
                text: "Error occured using Google Sign-In. Try again!")));
      }
    }

    return user;
  }

/*   static Future<User?> signInWithGoogle() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    User _user;
    GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
   UserCredential authResult =  await _auth.signInWithCredential(credential);
    _user = authResult.user!;
    assert(!_user.isAnonymous);
    assert(await _user.getIdToken() != null);
    User currentUser = _auth.currentUser!;
    assert(_user.uid == currentUser.uid);
    print("User Name: ${_user.displayName}");
    print("User Email ${_user.email}");
  } */
}
