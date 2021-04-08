import 'package:flutter/material.dart';

const Color _darkRed = Color.fromARGB(255, 0x75, 0x17, 0x1e);
const Color _lightRed = Color.fromARGB(255, 190, 40, 40);
const Color _mildWhite = Color.fromARGB(255, 0xfa, 0xfa, 0xfa);
const Color _lightGrey = Color.fromARGB(255, 215, 215, 215);
const Color _grey = Color.fromARGB(255, 0x7f, 0x7f, 0x7f);
const Color _strongGrey = Color.fromARGB(255, 90, 90, 90);
const Color _mildBlack = Color.fromARGB(255, 0x46, 0x46, 0x46);

ThemeData applicationLightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: _darkRed,
  accentColor: _lightGrey,
  hintColor: _grey,
  backgroundColor: _mildWhite,
  textTheme: TextTheme(
    headline6: TextStyle(
        fontSize: 17.0, color: _mildBlack, fontWeight: FontWeight.w300),
    headline5:
        TextStyle(fontSize: 17.0, color: _darkRed, fontWeight: FontWeight.w400),
    subtitle2:
        TextStyle(fontSize: 17.0, color: _grey, fontWeight: FontWeight.w300),
    headline4: TextStyle(
        fontSize: 17.0, color: _mildBlack, fontWeight: FontWeight.w300),
    headline3: TextStyle(
        fontSize: 17.0, color: _lightRed, fontWeight: FontWeight.w300),
    headline2: TextStyle(
        fontSize: 10.0, color: _mildBlack, fontWeight: FontWeight.w500),
    headline1:
        TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold, color: _darkRed),
    bodyText2: TextStyle(fontSize: 15.0, color: _darkRed),
    bodyText1: TextStyle(fontSize: 15.0, color: _darkRed),
  ),
  iconTheme: IconThemeData(color: _strongGrey),
  unselectedWidgetColor: _strongGrey,
  toggleableActiveColor: _darkRed,
  tabBarTheme: TabBarTheme(
    unselectedLabelColor: _strongGrey,
    labelColor: _strongGrey,
    labelPadding: EdgeInsets.all(0.0),
  ),
  canvasColor: Colors.white,
  cardColor: Colors.white,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        primary: _darkRed,
        padding: const EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: TextStyle(fontWeight: FontWeight.w400)),
  ),
);
