import 'dart:io';
import 'package:flutter/material.dart';
import 'package:edigit/constatnts.dart';
import 'package:edigit/screens/welcome/MyHttpOverrides.dart';
import 'package:edigit/screens/welcome/welcome_screen.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-DIGIT',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: WelcomeScreen(),
    );
  }
}
