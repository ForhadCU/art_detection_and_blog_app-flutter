import 'package:art_blog_app/screens/launcher/scr_launcher.dart';
import 'package:art_blog_app/screens/signin/scr_signin.dart';
import 'package:art_blog_app/screens/signup/scr_signup.dart';
import 'package:art_blog_app/utils/my_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        home: const LauncherPage());
  }
}
