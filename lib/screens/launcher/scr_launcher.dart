// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../controller/my_authentication_service.dart';
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
      decoration: BoxDecoration(
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
            style: TextStyle(color: MyColors.firstColor, fontSize: 24, fontWeight: FontWeight.w800),
          )
        ],
      ),
    ));
  }

  void mGoForward(User user) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return LandingScreen(user: user);
    }));
  }

  void mGoSignIn() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return const LoginScreen();
    }));
  }

  void mCheckUserLoggedInStatus() async {
    User? user = MyAuthenticationService.mCheckUserSignInStatus(
        firebaseAuth: firebaseAuth);
    await Future.delayed(const Duration(milliseconds: 8000));
      if (user != null) {
        mGoForward(user);
      } else {
        mGoSignIn();
      }
  }
}
