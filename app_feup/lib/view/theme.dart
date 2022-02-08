import 'package:flutter/material.dart';

const Color _darkRed = Color.fromARGB(255, 0x75, 0x17, 0x1e);
const Color _lightRed = Color.fromARGB(255, 190, 40, 40);
const Color _mildWhite = Color.fromARGB(255, 0xfa, 0xfa, 0xfa);
const Color _lightGrey = Color.fromARGB(255, 215, 215, 215);
const Color _grey = Color.fromARGB(255, 0x7f, 0x7f, 0x7f);
const Color _strongGrey = Color.fromARGB(255, 90, 90, 90);
const Color _mildBlack = Color.fromARGB(255, 0x30, 0x30, 0x30);

ThemeData applicationLightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: _darkRed,
  accentColor: _lightRed,
  backgroundColor: _mildWhite,
  scaffoldBackgroundColor: _mildWhite,
  hintColor: _lightGrey,
  dividerColor: _lightGrey,
  tabBarTheme: TabBarTheme(
    unselectedLabelColor: _strongGrey,
    labelColor: _strongGrey,
    labelPadding: EdgeInsets.all(0.0),
    indicator: ShapeDecoration(
        shape: UnderlineInputBorder(
            borderSide: BorderSide(width: 4.0, color: _darkRed))),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        primary: _darkRed,
        padding: const EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 15.0)),
  ),
  iconTheme: IconThemeData(color: _darkRed),
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
          primary: _darkRed,
          textStyle: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400))),
  checkboxTheme: CheckboxThemeData(
      checkColor: MaterialStateProperty.all(Colors.white),
      fillColor: MaterialStateColor.resolveWith(
        (states) {
          return states.contains(MaterialState.selected) ? _darkRed : _grey;
        },
      )),
  textTheme: TextTheme(
    headline1: TextStyle(fontSize: 40.0, fontWeight: FontWeight.w400),
    headline2: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w400),
    headline3: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w400),
    headline4: TextStyle(
        fontSize: 24.0, fontWeight: FontWeight.w300, color: _mildBlack),
    headline5: TextStyle(
        fontSize: 20.0, fontWeight: FontWeight.w400, color: _strongGrey),
    headline6: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),
    subtitle1: TextStyle(
        fontSize: 17.0, fontWeight: FontWeight.w300, color: _strongGrey),
    subtitle2: TextStyle(
        fontSize: 16.0, fontWeight: FontWeight.w300, color: _strongGrey),
    bodyText1: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
    bodyText2: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
    caption: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w400),
  ),
);

ThemeData applicationDarkTheme = ThemeData(
  brightness: Brightness.dark,
  hintColor: _grey,
  primaryColor: Colors.white,
  accentColor: Colors.white,
  backgroundColor: _mildBlack,
  scaffoldBackgroundColor: _mildBlack,
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
          primary: Colors.white,
          textStyle: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400))),
  textTheme: TextTheme(
    headline1: TextStyle(fontSize: 40.0, fontWeight: FontWeight.w400),
    headline2: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w400),
    headline3: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w400),
    headline4: TextStyle(
        fontSize: 24.0, fontWeight: FontWeight.w300, color: Colors.white),
    headline5: TextStyle(
        fontSize: 20.0, fontWeight: FontWeight.w400, color: Colors.white),
    headline6: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),
    subtitle1: TextStyle(
        fontSize: 17.0, fontWeight: FontWeight.w300, color: Colors.white),
    subtitle2: TextStyle(
        fontSize: 16.0, fontWeight: FontWeight.w300, color: Colors.white),
    bodyText1: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
    bodyText2: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
    caption: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w400),
  ),
  tabBarTheme: TabBarTheme(
    unselectedLabelColor: Colors.white,
    labelColor: Colors.white,
    labelPadding: EdgeInsets.all(0.0),
  ),
  checkboxTheme: applicationLightTheme.checkboxTheme,
);
