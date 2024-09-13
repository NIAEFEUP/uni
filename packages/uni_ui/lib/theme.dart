import 'package:flutter/material.dart';

const Color darkGray = Color.fromARGB(255, 48, 48, 48);
const Color mildWhite = Color.fromARGB(255, 255, 245, 243);
const Color darkRed = Color.fromARGB(255, 102, 9, 16);
const Color dust = Color.fromARGB(255, 228, 199, 184);
const Color pureWhite = Color.fromARGB(255, 255, 255, 255);
const Color pureBlack = Color.fromARGB(255, 0, 0, 0);
const Color normalGray = Color.fromARGB(255, 127, 127, 127);
const Color lightGray = Color.fromARGB(255, 229, 229, 229);
const Color salmon = Color.fromARGB(255, 227, 145, 145);

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

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  textTheme: _textTheme,
  colorScheme: ColorScheme.fromSeed(
      seedColor: darkRed,
      surface: mildWhite,
      surfaceContainer: mildWhite,
      primary: darkRed,
      onPrimary: pureWhite,
      secondary: dust,
      onSecondary: pureWhite,
      tertiary: salmon,
      onTertiary: pureWhite),
  primaryColor: darkRed,
  cardTheme: CardTheme(
    margin: EdgeInsets.all(4),
    color: mildWhite,
  ),
  dividerColor: lightGray,
  hintColor: lightGray,
  indicatorColor: darkRed,
  secondaryHeaderColor: normalGray,
  iconTheme: const IconThemeData(color: darkRed),
);
