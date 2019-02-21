import 'package:flutter/material.dart';

const Color primaryColor = Color.fromARGB(255, 0x8C, 0x2D, 0x19);
const Color subtitleColor = Color.fromARGB(255, 112, 112, 112);
const Color accentColor = Color.fromARGB(255, 235, 235, 235);
const Color greyTextColor = Color.fromARGB(255, 0x46, 0x46, 0x46);
const Color whiteTextColor = Color.fromARGB(255, 255, 255, 255);
const Color bodyTitle = Color.fromARGB(255, 131, 131, 131);
const Color hintColor = Colors.white;



ThemeData applicationTheme = new ThemeData(

  brightness: Brightness.light,
  primaryColor: primaryColor,
  accentColor: accentColor,
  hintColor: hintColor,

  fontFamily: 'Montserrat',

  textTheme: TextTheme(
    headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold, color: primaryColor),
    title: TextStyle(fontSize: 50.0, color: accentColor),
    body1: TextStyle(fontSize: 20.0, color: primaryColor),
  ),
);