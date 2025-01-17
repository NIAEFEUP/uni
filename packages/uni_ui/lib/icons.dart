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

  // Locations pins icons
  static const money = PhosphorIconsDuotone.money;
  static const coffee = PhosphorIconsDuotone.coffee;
  static const printer = PhosphorIconsDuotone.printer;
  static const lockers = PhosphorIconsDuotone.lockers;
  static const bookOpen = PhosphorIconsDuotone.bookOpen;
  static const bookOpenUser = PhosphorIconsDuotone.bookOpenUser;
  static const starFour = PhosphorIconsDuotone.starFour;
  static const storefront = PhosphorIconsDuotone.storefront;
  static const questionMark = PhosphorIconsDuotone.questionMark;
  static const toilet = PhosphorIconsDuotone.toiletPaper;
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
