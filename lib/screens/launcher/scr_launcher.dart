
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/const/keywords.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/firestore_service.dart';
import '../../controller/my_authentication_service.dart';
import '../../models/model.user.dart';
import '../../utils/my_colors.dart';
import '../../utils/my_screensize.dart';
import '../landing/scr.landing.dart';
import '../signin/scr_signin.dart';

class LauncherPage extends StatefulWidget {
  const LauncherPage({super.key});

  @override
  State<LauncherPage> createState() => _LauncherPageState();
}

class _LauncherPageState extends State<LauncherPage> {
  late FirebaseAuth firebaseAuth;
  @override
  void initState() {
    super.initState();
    // SystemChrome.setSystemUIOverlayStyle(style)
    firebaseAuth = FirebaseAuth.instance;

    mCheckUserLoggedInStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: MyScreenSize.mGetHeight(context, 100),
      width: MyScreenSize.mGetWidth(context, 100),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.white,
        /*    gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.1, 0.4, 0.7, 0.9],
          colors: [
            MyColors.firstColor.withOpacity(0.8),
            MyColors.firstColor,
            MyColors.firstColor,
            MyColors.firstColor
          ],
        ), */
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /*  SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.white30,
                strokeWidth: 2,
              )), */
          Image(image: AssetImage("assets/animations/launcher2.gif")),
          SizedBox(
            height: 12,
          ),
          Text(
            "App Name Goes Here",
            style: TextStyle(
                color: MyColors.firstColor,
                fontSize: 24,
                fontWeight: FontWeight.w800),
          )
        ],
      ),
    ));
  }

  void mGoForward(User user, UserData userData) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return LandingScreen(
        userData: userData,
      );
    }));
  }

  void mGoSignIn() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return const LoginScreen();
    }));
  }

  void mCheckUserLoggedInStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(milliseconds: 3000))
        .then((value) async {
      if (sharedPreferences.getBool(MyKeywords.sessionStatus) != null &&
          sharedPreferences.getBool(MyKeywords.sessionStatus)!) {
        User? user = MyAuthenticationService.mCheckUserSignInStatus(
            firebaseAuth: firebaseAuth);

        if (user != null) {
          await MyFirestoreService.mFetchUserData(
                  firebaseFirestore: FirebaseFirestore.instance,
                  email: user.email!)
              .then((value) {
            if (value != null) {
              mGoForward(user, value);
            }
          });
        } else {
          mGoSignIn();
        }
      } else {
        mGoSignIn();
      }
    });
  }
}
