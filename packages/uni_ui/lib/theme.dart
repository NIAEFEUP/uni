import 'package:flutter/material.dart';

// Widget Colors
const Color primaryVibrant = Color.fromARGB(255, 102, 9, 16);
const Color secondary = Color.fromARGB(255, 255, 245, 243);
const Color grayText = Color.fromARGB(255, 48, 48, 48);
const Color grayMiddle = Color.fromARGB(255, 127, 127, 127);
const Color background = Color.fromARGB(255, 255, 255, 255);
const Color details = Color.fromARGB(235, 177, 77, 84);
const Color divider = Color.fromARGB(255, 229, 229, 229);

const _lightTextTheme = TextTheme(
    displayLarge: TextStyle(
        fontSize: 40, fontWeight: FontWeight.w400, color: primaryVibrant),
    displayMedium: TextStyle(
        fontSize: 40, fontWeight: FontWeight.w400, color: primaryVibrant),
    displaySmall:
        TextStyle(fontSize: 28, fontWeight: FontWeight.w500, color: grayText),
    headlineLarge:
        TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: grayText),
    headlineMedium: TextStyle(
        fontSize: 20, fontWeight: FontWeight.w500, color: primaryVibrant),
    headlineSmall: TextStyle(
        fontSize: 16, fontWeight: FontWeight.w500, color: primaryVibrant),
    titleLarge:
        TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: background),
    titleMedium:
        TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: grayText),
    titleSmall:
        TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: background),
    bodyLarge:
        TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: grayText),
    bodyMedium:
        TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: grayMiddle),
    bodySmall: TextStyle(
        fontSize: 12, fontWeight: FontWeight.w400, color: primaryVibrant),
    labelLarge:
        TextStyle(fontSize: 9, fontWeight: FontWeight.w400, color: grayText),
    labelMedium:
        TextStyle(fontSize: 9, fontWeight: FontWeight.w400, color: grayMiddle),
    labelSmall: TextStyle(
        fontSize: 9, fontWeight: FontWeight.w400, color: primaryVibrant));

/*
var _lightTextTheme = TextTheme(
  displayLarge: _textTheme.displayLarge!,
  displayMedium: _textTheme.displayMedium!,
  displaySmall: _textTheme.displaySmall!,
  headlineLarge: _textTheme.headlineLarge!,
  headlineMedium: _textTheme.headlineMedium!.copyWith(color: primaryColor),
  headlineSmall: _textTheme.headlineSmall!,
  titleLarge: _textTheme.titleLarge!.copyWith(color: primaryColor),
  titleMedium: _textTheme.titleMedium!,
  titleSmall: _textTheme.titleSmall!,
  bodyLarge: _textTheme.bodyLarge!,
  bodyMedium: _textTheme.bodyMedium!,
  bodySmall: _textTheme.bodySmall!,
);
*/

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  textTheme: _lightTextTheme,
  colorScheme: ColorScheme.fromSeed(
      seedColor: primaryVibrant,
      surface: background,
      surfaceContainer: secondary,
      primary: primaryVibrant,
      onPrimary: background,
      secondary: secondary,
      onSecondary: background,
      tertiary: details,
      onTertiary: background),
  primaryColor: primaryVibrant,
  cardTheme: CardTheme(
    margin: EdgeInsets.all(4),
    color: secondary,
  ),
  dividerColor: divider,
  hintColor: details,
  indicatorColor: details,
  secondaryHeaderColor: secondary,
  iconTheme: const IconThemeData(color: primaryVibrant),
);

class BadgeColors {
  static const mt = Color(0xFF7ca5b8);
  static const en = Color(0xFF769c87);
  static const er = Color(0xFFab4d39);
  static const ee = Color(0xFFfbc11f);
}
