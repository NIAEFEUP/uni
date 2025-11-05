import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

const Color primary = Color.fromARGB(255, 102, 9, 16);
const Color transparent = Color.fromARGB(0, 255, 255, 255);
const Color black = Color.fromARGB(255, 0, 0, 0);
const Color white = Color.fromARGB(255, 255, 255, 255);

class Theme extends InheritedWidget {
  const Theme({super.key, required this.data, required super.child});

  final ThemeData data;

  static ThemeData of(BuildContext context) {
    final Theme? result = context.dependOnInheritedWidgetOfExactType<Theme>();
    assert(result != null, 'No Theme found in context');
    return result!.data;
  }

  @override
  bool updateShouldNotify(Theme oldWidget) {
    // Rebuild dependent widgets only if the data object itself changes.
    return data != oldWidget.data;
  }
}

class ThemeData {
  const ThemeData({
    required this.brightness,
    required this.primaryVibrant,
    required this.secondary,
    required this.grayText,
    required this.grayMiddle,
    required this.grayLight,
    required this.background,
    required this.details,
    required this.divider,
    required this.focused,
    required this.transparent,
    required this.badgeColors,
    required this.textStyles,
  });

  final Brightness brightness;
  final BadgeColors badgeColors;
  final TextStyles textStyles;

  final Color primaryVibrant;
  final Color secondary;
  final Color grayText;
  final Color grayMiddle;
  final Color grayLight;
  final Color background;
  final Color details;
  final Color divider;
  final Color focused;
  final Color transparent;

  factory ThemeData.light() {
    const Color primaryVibrant = Color.fromARGB(255, 102, 9, 16);
    const Color secondary = Color.fromARGB(255, 255, 245, 243);
    const Color grayText = Color.fromARGB(255, 48, 48, 48);
    const Color grayMiddle = Color.fromARGB(255, 127, 127, 127);
    const Color grayLight = Color.fromARGB(255, 245, 245, 245);
    const Color background = Color.fromARGB(255, 255, 255, 255);
    const Color details = Color.fromARGB(235, 177, 77, 84);
    const Color divider = Color.fromARGB(255, 229, 229, 229);
    const Color focused = Color.fromARGB(64, 177, 77, 84);
    const Color transparent = Color.fromARGB(0, 255, 255, 255);

    return ThemeData(
      brightness: Brightness.light,
      primaryVibrant: primaryVibrant,
      secondary: secondary,
      grayText: grayText,
      grayMiddle: grayMiddle,
      grayLight: grayLight,
      background: background,
      details: details,
      divider: divider,
      focused: focused,
      transparent: transparent,
      badgeColors: const BadgeColors(),
      textStyles: TextStyles.fromColors(
        primary: primaryVibrant,
        text: grayText,
        textMiddle: grayMiddle,
        background: background,
      ),
    );
  }

  // factory ThemeData.dark() {
  //   const Color primaryVibrant = Color.fromARGB(255, 218, 110, 116);
  //   const Color secondary = Color.fromARGB(255, 30, 30, 30);
  //   const Color grayText = Color.fromARGB(255, 227, 227, 227);
  //   const Color grayMiddle = Color.fromARGB(255, 150, 150, 150);
  //   const Color grayLight = Color.fromARGB(255, 45, 45, 45);
  //   const Color background = Color.fromARGB(255, 18, 18, 18);
  //   const Color details = Color.fromARGB(235, 218, 110, 116);
  //   const Color divider = Color.fromARGB(255, 60, 60, 60);
  //   const Color focused = Color.fromARGB(64, 218, 110, 116);
  //   const Color transparent = Color.fromARGB(0, 255, 255, 255);

  //   return ThemeData(
  //     brightness: Brightness.dark,
  //     primaryVibrant: primaryVibrant,
  //     secondary: secondary,
  //     grayText: grayText,
  //     grayMiddle: grayMiddle,
  //     grayLight: grayLight,
  //     background: background,
  //     details: details,
  //     divider: divider,
  //     focused: focused,
  //     transparent: transparent,
  //     badgeColors: const BadgeColors(),
  //     // Create text styles using the dark theme colors
  //     textStyles: TextStyles.fromColors(
  //       primary: primaryVibrant,
  //       text: grayText,
  //       textMiddle: grayMiddle,
  //       background: background,
  //     ),
  //   );
  // }

  TextStyle get displayLarge => textStyles.displayLarge;
  TextStyle get displayMedium => textStyles.displayMedium;
  TextStyle get displaySmall => textStyles.displaySmall;
  TextStyle get headlineLarge => textStyles.headlineLarge;
  TextStyle get headlineMedium => textStyles.headlineMedium;
  TextStyle get headlineSmall => textStyles.headlineSmall;
  TextStyle get titleLarge => textStyles.titleLarge;
  TextStyle get titleMedium => textStyles.titleMedium;
  TextStyle get titleSmall => textStyles.titleSmall;
  TextStyle get bodyLarge => textStyles.bodyLarge;
  TextStyle get bodyMedium => textStyles.bodyMedium;
  TextStyle get bodySmall => textStyles.bodySmall;
  TextStyle get labelLarge => textStyles.labelLarge;
  TextStyle get labelMedium => textStyles.labelMedium;
  TextStyle get labelSmall => textStyles.labelSmall;
}

class TextStyles {
  TextStyles.fromColors({
    required Color primary,
    required Color text,
    required Color textMiddle,
    required Color background,
  }) : displayLarge = TextStyle(
         fontSize: 40,
         fontWeight: FontWeight.w400,
         color: primary,
       ),
       displayMedium = TextStyle(
         fontSize: 40,
         fontWeight: FontWeight.w400,
         color: primary,
       ),
       displaySmall = TextStyle(
         fontSize: 28,
         fontWeight: FontWeight.w500,
         color: text,
       ),
       headlineLarge = TextStyle(
         fontSize: 20,
         fontWeight: FontWeight.w500,
         color: text,
       ),
       headlineMedium = TextStyle(
         fontSize: 20,
         fontWeight: FontWeight.w500,
         color: primary,
       ),
       headlineSmall = TextStyle(
         fontSize: 16,
         fontWeight: FontWeight.w500,
         color: primary,
       ),
       titleLarge = TextStyle(
         fontSize: 16,
         fontWeight: FontWeight.w500,
         color: background,
       ),
       titleMedium = TextStyle(
         fontSize: 12,
         fontWeight: FontWeight.w500,
         color: text,
       ),
       titleSmall = TextStyle(
         fontSize: 12,
         fontWeight: FontWeight.w400,
         color: background,
       ),
       bodyLarge = TextStyle(
         fontSize: 12,
         fontWeight: FontWeight.w400,
         color: text,
       ),
       bodyMedium = TextStyle(
         fontSize: 12,
         fontWeight: FontWeight.w400,
         color: textMiddle,
       ),
       bodySmall = TextStyle(
         fontSize: 12,
         fontWeight: FontWeight.w400,
         color: primary,
       ),
       labelLarge = TextStyle(
         fontSize: 9,
         fontWeight: FontWeight.w400,
         color: text,
       ),
       labelMedium = TextStyle(
         fontSize: 9,
         fontWeight: FontWeight.w400,
         color: textMiddle,
       ),
       labelSmall = TextStyle(
         fontSize: 9,
         fontWeight: FontWeight.w400,
         color: primary,
       );

  final TextStyle displayLarge;
  final TextStyle displayMedium;
  final TextStyle displaySmall;
  final TextStyle headlineLarge;
  final TextStyle headlineMedium;
  final TextStyle headlineSmall;
  final TextStyle titleLarge;
  final TextStyle titleMedium;
  final TextStyle titleSmall;
  final TextStyle bodyLarge;
  final TextStyle bodyMedium;
  final TextStyle bodySmall;
  final TextStyle labelLarge;
  final TextStyle labelMedium;
  final TextStyle labelSmall;
}

class BadgeColors {
  const BadgeColors();
  // Schedule
  final Color t = const Color(0xFFfbc11f);
  final Color tp = const Color(0xFFd3944c);
  final Color p = const Color(0xFFab4d39);
  final Color pl = const Color(0xFF769c87);
  final Color ot = const Color(0xFF7ca5b8);
  final Color tc = const Color(0xFFcdbeb1);
  final Color s = const Color(0xFF917c9b);

  // Exams
  final Color mt = const Color(0xFF7ca5b8);
  final Color en = const Color(0xFF769c87);
  final Color er = const Color(0xFFab4d39);
  final Color ee = const Color(0xFFfbc11f);
}

class AppSystemOverlayStyles {
  AppSystemOverlayStyles._();

  static const base = SystemUiOverlayStyle(
    systemNavigationBarContrastEnforced: false,
    systemNavigationBarColor: Color.fromARGB(0, 255, 255, 255),
    systemNavigationBarDividerColor: Color.fromARGB(0, 255, 255, 255),
  );
}
