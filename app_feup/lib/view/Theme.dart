import 'package:flutter/material.dart';
//fff9f9f9
const Color titleColor = Color.fromARGB(255, 0xb1, 0xb1, 0xb1);
const Color primaryColor = Color.fromARGB(255, 0x75, 0x17, 0x1e);
const Color tonedDownPrimary = Color.fromARGB(255, 0xd5, 0x83, 0x89);
const Color subtitleColor = Color.fromARGB(255, 0x5f, 0x5f, 0x5f);
const Color accentColor = Color.fromARGB(255, 235, 235, 235);
const Color greyTextColor = Color.fromARGB(255, 0x26, 0x26, 0x26);
const Color whiteTextColor = Color.fromARGB(255, 255, 255, 255);
const Color bodyTitle = Color.fromARGB(255, 131, 131, 131);
const Color greyBorder = Color.fromARGB(64, 0x46, 0x46, 0x46);
const Color backgroundColor = Color.fromARGB(255, 0xfa, 0xfa, 0xfa);
const Color toastColor = Color.fromARGB(255, 100, 100, 100);
const Color lightGreyTextColor = Color.fromARGB(255, 150, 150, 150);

const Color divider = Color.fromARGB(255, 180, 180, 180);
const Color hintColor = Colors.white;

ThemeData applicationTheme = new ThemeData(

  brightness: Brightness.light,
  primaryColor: primaryColor,
  accentColor: accentColor,
  hintColor: hintColor,
  backgroundColor: backgroundColor,

//  fontFamily: 'Raleway',

  textTheme: TextTheme(
    headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold, color: primaryColor),
    title: TextStyle(fontSize: 17.0, color: titleColor, fontWeight: FontWeight.w400),
    body1: TextStyle(fontSize: 15.0, color: primaryColor),
    subtitle: TextStyle(fontSize: 20.0, color: subtitleColor, fontWeight: FontWeight.w200),
    display1: TextStyle(fontSize: 17.0, color: greyTextColor, fontWeight: FontWeight.w200),
    display2: TextStyle(fontSize: 17.0, color: tonedDownPrimary, fontWeight: FontWeight.w300),
    display3: TextStyle(fontSize: 10.0, color: titleColor, fontWeight: FontWeight.w500),
  ),


);