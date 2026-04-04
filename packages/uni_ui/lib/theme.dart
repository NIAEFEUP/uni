import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// --- Widget Colors ---
const Color _lightTextColor = Color(0xFF660910);
const Color _darkTextColor = Color(0xFFE5C8C7);

// --- Text Themes ---

// Light Theme Typography
final TextTheme _lightTextTheme = const TextTheme(
  displayLarge: TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w500,
    color: _lightTextColor,
  ),
  displayMedium: TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.normal,
    color: _lightTextColor,
  ),
  displaySmall: TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.normal,
    color: _lightTextColor,
  ),

  headlineLarge: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: _lightTextColor,
  ),
  headlineMedium: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.normal,
    color: _lightTextColor,
  ),
  headlineSmall: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.normal,
    color: _lightTextColor,
  ),

  titleLarge: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: _lightTextColor,
  ),
  titleMedium: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: _lightTextColor,
  ),
  titleSmall: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: _lightTextColor,
  ),

  bodyLarge: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: _lightTextColor,
  ),
  bodyMedium: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: _lightTextColor,
  ),
  bodySmall: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: _lightTextColor,
  ),

  labelLarge: TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w500,
    color: _lightTextColor,
  ),
  labelMedium: TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.normal,
    color: _lightTextColor,
  ),
  labelSmall: TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.normal,
    color: _lightTextColor,
  ),
);

// Dark Theme Typography
final TextTheme _darkTextTheme = const TextTheme(
  displayLarge: TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w500,
    color: _darkTextColor,
  ),
  displayMedium: TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.normal,
    color: _darkTextColor,
  ),
  displaySmall: TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.normal,
    color: _darkTextColor,
  ),

  headlineLarge: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: _darkTextColor,
  ),
  headlineMedium: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.normal,
    color: _darkTextColor,
  ),
  headlineSmall: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.normal,
    color: _darkTextColor,
  ),

  titleLarge: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: _darkTextColor,
  ),
  titleMedium: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: _darkTextColor,
  ),
  titleSmall: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: _darkTextColor,
  ),

  bodyLarge: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: _darkTextColor,
  ),
  bodyMedium: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: _darkTextColor,
  ),
  bodySmall: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: _darkTextColor,
  ),

  labelLarge: TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w500,
    color: _darkTextColor,
  ),
  labelMedium: TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.normal,
    color: _darkTextColor,
  ),
  labelSmall: TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.normal,
    color: _darkTextColor,
  ),
);

// --- ThemeData Definitions ---

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  textTheme: _lightTextTheme,
  colorScheme: ColorScheme.light(
    primary: const Color(0xFF660910),
    onPrimary: const Color(0xFFB14D54).withValues(alpha: 0.15),
    onPrimaryFixed: const Color(0xFFFFF5F3),
    secondary: const Color(0xFFFFF5F3),
    onSecondary: const Color(0xFF660910),
    surface: const Color(0xFFFFFFFF),
    onSurface: const Color(0xFF313131),
    shadow: Colors.black.withValues(alpha: 0.03),
  ),
  iconTheme: const IconThemeData(color: Color(0xFF660910)),
  disabledColor: const Color(0xFF767575),
);

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  textTheme: _darkTextTheme,
  colorScheme: ColorScheme.dark(
    primary: const Color(0xFF2F0A0C),
    onPrimary: const Color(0xFF250103),
    onPrimaryFixed: const Color(0xFFE5C8C7),
    secondary: const Color(0xFF2F1313),
    onSecondary: const Color(0xFFE5C8C7),
    surface: const Color(0xFF0F0607),
    onSurface: const Color(0xFFFFF5F3),
    shadow: Colors.black.withValues(alpha: 0.03),
  ),
  iconTheme: const IconThemeData(color: Color(0xFFE5C8C7)),
  disabledColor: const Color(0xFF614D4F),
);

// --- Custom Colors ---

class BadgeColors {
  // Schedule
  static const t = Color(0xFFFBC11F);
  static const tp = Color(0xFFD3944C);
  static const p = Color(0xFFAB4D39);
  static const pl = Color(0xFF769C87);
  static const ot = Color(0xFF7CA5B8);
  static const tc = Color(0xFFCDBEB1);
  static const s = Color(0xFF917C9B);

  // Exams
  static const mt = Color(0xFF7CA5B8);
  static const en = Color(0xFF769C87);
  static const er = Color(0xFFAB4D39);
  static const ee = Color(0xFFFBC11F);
}

class AppSystemOverlayStyles {
  AppSystemOverlayStyles._();

  static const base = SystemUiOverlayStyle(
    systemNavigationBarContrastEnforced: false,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
  );
}
