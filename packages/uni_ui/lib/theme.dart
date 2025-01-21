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
  displaySmall: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
  headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
  headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
  headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
  titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
  titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
  titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
  bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
  bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
  bodySmall: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
);

var _lightTextTheme = TextTheme(
  displayLarge: _textTheme.displayLarge!,
  displayMedium: _textTheme.displayMedium!,
  displaySmall: _textTheme.displaySmall!,
  headlineLarge: _textTheme.headlineLarge!,
  headlineMedium: _textTheme.headlineMedium!.copyWith(color: darkRed),
  headlineSmall: _textTheme.headlineSmall!,
  titleLarge: _textTheme.titleLarge!.copyWith(color: darkRed),
  titleMedium: _textTheme.titleMedium!,
  titleSmall: _textTheme.titleSmall!,
  bodyLarge: _textTheme.bodyLarge!,
  bodyMedium: _textTheme.bodyMedium!,
  bodySmall: _textTheme.bodySmall!,
);

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  textTheme: _lightTextTheme,
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
    shadowColor: Colors.black.withOpacity(0.25),
  ),
  dividerColor: lightGray,
  hintColor: lightGray,
  indicatorColor: darkRed,
  secondaryHeaderColor: normalGray,
  iconTheme: const IconThemeData(color: darkRed),
  scaffoldBackgroundColor: pureWhite,
);

class BadgeColors {
  static const te = Color(0xFFfbc11f);
  static const tp = Color(0xFFd3944c);
  static const p = Color(0xFFab4d39);
  static const pl = Color(0xFF769c87);
  static const ot = Color(0xFF7ca5b8);
  static const tc = Color(0xFFcdbeb1);
  static const s = Color(0xFF917c9b);
  static const mt = Color(0xFF7ca5b8);
  static const en = Color(0xFF769c87);
  static const er = Color(0xFFab4d39);
  static const ee = Color(0xFFfbc11f);
}