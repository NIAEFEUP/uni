import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// A list of all available icons
class UniIcons {
  static const lecture = PhosphorIconsDuotone.lectern;
  static const exam = PhosphorIconsDuotone.exam;
  static const course = PhosphorIconsDuotone.certificate;

  static const home = PhosphorIconsDuotone.house;
  static const graduationCap = PhosphorIconsDuotone.graduationCap;
  static const restaurant = PhosphorIconsDuotone.forkKnife;
  static const faculty = PhosphorIconsDuotone.buildings;
  static const map = PhosphorIconsDuotone.mapTrifold;

  static const canteen = PhosphorIconsDuotone.cookingPot;
  static const snackBar = PhosphorIconsDuotone.hamburger;
  static const soup = PhosphorIconsDuotone.bowlSteam;
  static const meat = PhosphorIconsDuotone.cow;
  static const fish = PhosphorIconsDuotone.fish;
  static const vegetarian = PhosphorIconsDuotone.plant;
  static const salad = PhosphorIconsDuotone.carrot;
  static const diet = PhosphorIconsDuotone.clipboardText;
  static const dishOfTheDay = PhosphorIconsDuotone.calendarDot;

  static const heartOutline = PhosphorIconsRegular.heart;
  static const heartFill = PhosphorIconsFill.heart;

}

// The same as default Icon class from material.dart but allowing to use PhosphorIcons duotone icons
class UniIcon extends PhosphorIcon {
  const UniIcon(
    IconData icon, {
    super.key,
    double size = 24,
    Color? color,
    String? semanticLabel,
    TextDirection? textDirection,
  }) : super(
          icon,
          size: size,
          color: color,
          semanticLabel: semanticLabel,
          textDirection: textDirection,
        );
}
