import 'package:flutter/material.dart';

const Color darkRed = Color.fromARGB(255, 0x75, 0x17, 0x1e);
const Color lightRed = Color.fromARGB(255, 180, 30, 30);

const Color _mildWhite = Color.fromARGB(255, 0xfa, 0xfa, 0xfa);
const Color _lightGrey = Color.fromARGB(255, 215, 215, 215);
const Color _grey = Color.fromARGB(255, 0x7f, 0x7f, 0x7f);
const Color _strongGrey = Color.fromARGB(255, 90, 90, 90);
const Color _mildBlack = Color.fromARGB(255, 43, 43, 43);
const Color _darkishBlack = Color.fromARGB(255, 43, 43, 43);
const Color _darkBlack = Color.fromARGB(255, 27, 27, 27);

const _textTheme = TextTheme(
  headline1: TextStyle(fontSize: 40.0, fontWeight: FontWeight.w400),
  headline2: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w400),
  headline3: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w400),
  headline4: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w300),
  headline5: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400),
  headline6: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),
  subtitle1: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w300),
  subtitle2: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300),
  bodyText1: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
  bodyText2: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
  caption: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w400),
);

ThemeData applicationLightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
        seedColor: darkRed,
        brightness: Brightness.light,
        background: _grey,
        primary: darkRed,
        onPrimary: Colors.white,
        secondary: darkRed,
        onSecondary: Colors.white,
        tertiary: lightRed,
        onTertiary: Colors.black),
    brightness: Brightness.light,
    primaryColor: darkRed,
    canvasColor: _mildWhite,
    backgroundColor: _mildWhite,
    scaffoldBackgroundColor: _mildWhite,
    hintColor: _lightGrey,
    dividerColor: _lightGrey,
    cardColor: Colors.white,
    indicatorColor: darkRed,
    primaryTextTheme: Typography().black.copyWith(
        headline4: const TextStyle(color: _strongGrey),
        bodyText1: const TextStyle(color: _strongGrey)),
    toggleableActiveColor: darkRed,
    iconTheme: const IconThemeData(color: darkRed),
    textTheme: _textTheme);

ThemeData applicationDarkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
        seedColor: lightRed,
        brightness: Brightness.dark,
        background: _grey,
        primary: darkRed,
        onPrimary: Colors.white,
        secondary: lightRed,
        onSecondary: Colors.black,
        tertiary: _mildWhite,
        onTertiary: Colors.white),
    brightness: Brightness.dark,
    primaryColor: _mildWhite,
    canvasColor: _darkBlack,
    backgroundColor: _darkBlack,
    scaffoldBackgroundColor: _darkBlack,
    cardColor: _mildBlack,
    hintColor: _darkishBlack,
    indicatorColor: Colors.white,
    primaryTextTheme: Typography().white,
    toggleableActiveColor: _mildBlack,
    textTheme: _textTheme.apply(bodyColor: _lightGrey));
