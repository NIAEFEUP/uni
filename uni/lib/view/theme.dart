import 'package:flutter/material.dart';

const Color darkRed = Color.fromARGB(255, 0x75, 0x17, 0x1e);
const Color lightRed = Color.fromARGB(255, 180, 30, 30);

const Color _mildWhite = Color.fromARGB(255, 0xfa, 0xfa, 0xfa);
const Color _lightGrey = Color.fromARGB(255, 215, 215, 215);
const Color _strongGrey = Color.fromARGB(255, 90, 90, 90);
const Color _mildBlack = Color.fromARGB(255, 43, 43, 43);
const Color _darkishBlack = Color.fromARGB(255, 43, 43, 43);
const Color _darkBlack = Color.fromARGB(255, 27, 27, 27);
const Color _lightBlue = Color.fromARGB(255, 172, 193, 206);

const _textTheme = TextTheme(
  displayLarge: TextStyle(fontSize: 40, fontWeight: FontWeight.w400),
  displayMedium: TextStyle(fontSize: 32, fontWeight: FontWeight.w400),
  displaySmall: TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
  headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
  headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
  titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
  titleMedium: TextStyle(fontSize: 17, fontWeight: FontWeight.w300),
  titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
  bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
  bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
  bodySmall: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
);

ThemeData applicationLightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: darkRed,
    background: _mildWhite,
    primary: darkRed,
    onPrimary: Colors.white,
    secondary: darkRed,
    onSecondary: Colors.white,
    tertiary: lightRed,
    onTertiary: Colors.black,
  ),
  primaryColor: darkRed,
  cardColor: Colors.white,
  dividerColor: _lightGrey,
  hintColor: _lightGrey,
  indicatorColor: darkRed,
  primaryTextTheme: Typography().black.copyWith(
        headlineMedium: const TextStyle(color: _strongGrey),
        bodyLarge: const TextStyle(color: _strongGrey),
      ),
  iconTheme: const IconThemeData(color: darkRed),
  textTheme: _textTheme,
);

ThemeData applicationDarkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: lightRed,
    brightness: Brightness.dark,
    background: _darkBlack,
    primary: _lightGrey,
    onPrimary: _darkishBlack,
    secondary: _lightBlue,
    onSecondary: _darkishBlack,
    tertiary: _lightGrey,
    onTertiary: _darkishBlack,
  ),
  primaryColor: _lightGrey,
  cardColor: _mildBlack,
  dividerColor: _strongGrey,
  hintColor: _darkishBlack,
  indicatorColor: _lightGrey,
  primaryTextTheme: Typography().white,
  iconTheme: const IconThemeData(color: _lightGrey),
  textTheme: _textTheme.apply(bodyColor: _lightGrey),
);
