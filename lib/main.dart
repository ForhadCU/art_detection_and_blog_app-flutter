import 'package:art_blog_app/screens/signup/scr_signup.dart';
import 'package:art_blog_app/utils/my_colors.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Art Blog App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: MyColors.firstColor),
          useMaterial3: true,
        ),
        home: const SignupScreen());
  }
}
