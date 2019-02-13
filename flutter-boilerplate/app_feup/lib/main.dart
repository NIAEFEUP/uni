import 'package:flutter/material.dart';
import 'view/Pages/SplashPageView.dart';
import 'view/Theme.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'APP FEUP',
      theme: applicationTheme,
      home: SplashScreen(),
    );
  }
}