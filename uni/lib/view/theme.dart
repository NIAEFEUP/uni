import 'package:flutter/material.dart';

const Color _darkRed = Color.fromARGB(255, 0x75, 0x17, 0x1e);
const Color _lightRed = Color.fromARGB(255, 180, 30, 30);
const Color _white = Color.fromARGB(255, 232, 232, 232);
const Color _mildWhite = Color.fromARGB(255, 0xfa, 0xfa, 0xfa);
const Color _lightGrey = Color.fromARGB(255, 215, 215, 215);
const Color _mildGrey = Color.fromARGB(255, 180, 180, 180);
const Color _grey = Color.fromARGB(255, 0x7f, 0x7f, 0x7f);
const Color _strongGrey = Color.fromARGB(255, 90, 90, 90);
const Color _mildBlack = Color.fromARGB(255, 0x30, 0x30, 0x30);
const Color _darkBlack = Color.fromARGB(255, 27, 27, 27);

ThemeData applicationLightTheme = ThemeData(
  colorScheme:
      ColorScheme.fromSeed(seedColor: _darkRed, brightness: Brightness.light),
  brightness: Brightness.light,
  primaryColor: _darkRed,
  canvasColor: _mildWhite,
  backgroundColor: _mildWhite,
  scaffoldBackgroundColor: _mildWhite,
  hintColor: _lightGrey,
  dividerColor: _lightGrey,
  cardColor: const Color.fromARGB(255, 0xff, 0xff, 0xff),
  tabBarTheme: const TabBarTheme(
    unselectedLabelColor: _strongGrey,
    labelColor: _strongGrey,
    labelPadding: EdgeInsets.all(0.0),
    indicator: ShapeDecoration(
        shape: UnderlineInputBorder(
            borderSide: BorderSide(width: 4.0, color: _darkRed))),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        backgroundColor: _darkRed,
        padding: const EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle:
            const TextStyle(fontWeight: FontWeight.w400, fontSize: 15.0)),
  ),
  iconTheme: const IconThemeData(color: _darkRed),
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
          foregroundColor: _darkRed,
          textStyle:
              const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400))),
  checkboxTheme: CheckboxThemeData(
      checkColor: MaterialStateProperty.all(Colors.white),
      fillColor: MaterialStateColor.resolveWith(
        (states) {
          return states.contains(MaterialState.selected) ? _darkRed : _grey;
        },
      )),
  textTheme: const TextTheme(
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
  colorScheme:
      ColorScheme.fromSeed(seedColor: _darkRed, brightness: Brightness.dark),
  brightness: Brightness.dark,
  hintColor: const Color.fromARGB(255, 43, 43, 43),
  dividerColor: const Color.fromARGB(255, 100, 100, 100),
  primaryColor: _white,
  canvasColor: _darkBlack,
  backgroundColor: _darkBlack,
  scaffoldBackgroundColor: _darkBlack,
  cardColor: const Color.fromARGB(255, 43, 43, 43),
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
          foregroundColor: _white,
          textStyle:
              const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400))),
  textTheme: const TextTheme(
    headline1: TextStyle(fontSize: 40.0, fontWeight: FontWeight.w400),
    headline2: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w400),
    headline3: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w400),
    headline4: TextStyle(
        fontSize: 24.0, fontWeight: FontWeight.w300, color: Colors.white),
    headline5: TextStyle(
        fontSize: 20.0, fontWeight: FontWeight.w400, color: _mildGrey),
    headline6: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),
    subtitle1: TextStyle(
        fontSize: 17.0, fontWeight: FontWeight.w300, color: _lightGrey),
    subtitle2: TextStyle(
        fontSize: 16.0, fontWeight: FontWeight.w300, color: _mildGrey),
    bodyText1: TextStyle(
        fontSize: 16.0, fontWeight: FontWeight.w400, color: _lightGrey),
    bodyText2: TextStyle(
        fontSize: 14.0, fontWeight: FontWeight.w400, color: _mildGrey),
    caption: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w400),
  ),
  tabBarTheme: const TabBarTheme(
    unselectedLabelColor: _white,
    labelColor: _white,
    labelPadding: EdgeInsets.all(0.0),
  ),
  checkboxTheme: applicationLightTheme.checkboxTheme,
  elevatedButtonTheme: applicationLightTheme.elevatedButtonTheme,
  iconTheme: const IconThemeData(color: _white),
);
