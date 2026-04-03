import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Widget Colors
const Color primaryVibrant = Color.fromARGB(255, 102, 9, 16);
const Color secondary = Color.fromARGB(255, 255, 245, 243);
const Color grayText = Color.fromARGB(255, 48, 48, 48);
const Color grayMiddle = Color.fromARGB(255, 127, 127, 127);
const Color grayLight = Color.fromARGB(255, 245, 245, 245);
const Color background = Color.fromARGB(255, 255, 255, 255);
const Color details = Color.fromARGB(235, 177, 77, 84);
const Color divider = Color.fromARGB(255, 229, 229, 229);
const Color focused = Color.fromARGB(64, 177, 77, 84);

const _lightTextTheme = TextTheme(
  displayLarge: TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w400,
    color: Color(0xFF660910),
  ),
  displayMedium: TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w400,
    color: Color(0xFF660910),
  ),
  displaySmall: TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w500,
    color: Color(0xFF660910),
  ),
  headlineLarge: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: Color(0xFF660910),
  ),
  headlineMedium: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: Color(0xFF660910),
  ),
  headlineSmall: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Color(0xFF660910),
  ),
  titleLarge: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Color(0xFF660910),
  ),
  titleMedium: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Color(0xFF660910),
  ),
  titleSmall: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Color(0xFF660910),
  ),
  bodyLarge: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Color(0xFF660910),
  ),
  bodyMedium: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Color(0xFF660910),
  ),
  bodySmall: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Color(0xFF660910),
  ),
  labelLarge: TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w400,
    color: Color(0xFF660910),
  ),
  labelMedium: TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w400,
    color: Color(0xFF660910),
  ),
  labelSmall: TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w400,
    color: Color(0xFF660910),
  ),
);

const _darkTextTheme = TextTheme(
  displayLarge: TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w400,
    color: Color(0xFFE5C8C7),
  ),
  displayMedium: TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w400,
    color: Color(0xFFE5C8C7),
  ),
  displaySmall: TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w500,
    color: Color(0xFFE5C8C7),
  ),
  headlineLarge: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: Color(0xFFE5C8C7),
  ),
  headlineMedium: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: Color(0xFFE5C8C7),
  ),
  headlineSmall: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Color(0xFFE5C8C7),
  ),
  titleLarge: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Color(0xFFE5C8C7),
  ),
  titleMedium: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Color(0xFFE5C8C7),
  ),
  titleSmall: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Color(0xFFE5C8C7),
  ),
  bodyLarge: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Color(0xFFE5C8C7),
  ),
  bodyMedium: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Color(0xFFE5C8C7),
  ),
  bodySmall: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Color(0xFFE5C8C7),
  ),
  labelLarge: TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w400,
    color: Color(0xFFE5C8C7),
  ),
  labelMedium: TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w400,
    color: Color(0xFFE5C8C7),
  ),
  labelSmall: TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w400,
    color: Color(0xFFE5C8C7),
  ),
);

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  textTheme: _lightTextTheme,
  colorScheme: ColorScheme.light(
    primary: Color(0xFF660910),
    inversePrimary: Color.fromARGB(40, 177, 77, 84),
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF313131),
    secondary: Color(0xFFFFF5F3),
    onSecondaryContainer: Color(0xFF660910),
    shadow: Color(0xFF000000).withValues(alpha: 0.03),
  ),
  iconTheme: IconThemeData(color: Color(0xFF660910)),
  disabledColor: Color.fromARGB(255, 118, 117, 117),
);

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  textTheme: _darkTextTheme,
  colorScheme: ColorScheme.dark(
    primary: Color(0xFF2F0A0C),
    inversePrimary: Color(0xFF250103),
    surface: Color(0xFF0F0607),
    onSurface: Color(0xFFFFF5F3),
    secondary: Color(0xFF2F1313),
    onSecondaryContainer: Color(0xFFE5C8C7),
    shadow: Color(0xFF000000).withValues(alpha: 0.03),
  ),
  iconTheme: IconThemeData(color: Color(0xFFE5C8C7)),
  disabledColor: Color(0xFF614D4F),
);

class BadgeColors {
  // Schedule
  static const t = Color(0xFFfbc11f);
  static const tp = Color(0xFFd3944c);
  static const p = Color(0xFFab4d39);
  static const pl = Color(0xFF769c87);
  static const ot = Color(0xFF7ca5b8);
  static const tc = Color(0xFFcdbeb1);
  static const s = Color(0xFF917c9b);

  // Exams
  static const mt = Color(0xFF7ca5b8);
  static const en = Color(0xFF769c87);
  static const er = Color(0xFFab4d39);
  static const ee = Color(0xFFfbc11f);
}

class AppSystemOverlayStyles {
  AppSystemOverlayStyles._();

  static const base = SystemUiOverlayStyle(
    systemNavigationBarContrastEnforced: false,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
  );
}
