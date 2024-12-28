import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// A list of all available icons
class UniIcons {
  static const lecture = PhosphorIconsDuotone.lectern;
  static const exam = PhosphorIconsDuotone.exam;
  static const course = PhosphorIconsDuotone.certificate;
  static const calendar = PhosphorIconsDuotone.calendarDots;
  static const courses = PhosphorIconsDuotone.certificate;
  static const classes = PhosphorIconsDuotone.usersThree;
  static const files = PhosphorIconsDuotone.folderOpen;
  static const notebook = PhosphorIconsDuotone.notebook;
  static const email = PhosphorIconsDuotone.paperPlaneTilt;
  static const location = PhosphorIconsDuotone.mapPin;
  static const clock = PhosphorIconsDuotone.clock;
  static const calendarBlank = PhosphorIconsDuotone.calendarBlank;
  static const mapPin = PhosphorIconsDuotone.mapPin;
  static const eyeVisible = PhosphorIconsDuotone.eye;
  static const eyeHidden = PhosphorIconsDuotone.eyeSlash;
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
