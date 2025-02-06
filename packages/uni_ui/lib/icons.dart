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

  static const pallete = PhosphorIconsDuotone.palette;
  static const globeHemisphereWest = PhosphorIconsDuotone.globeHemisphereWest;
  static const chartBar = PhosphorIconsDuotone.chartBar;
  static const notification = PhosphorIconsDuotone.notification;
  static const thumbsUp = PhosphorIconsDuotone.thumbsUp;
  static const gavel = PhosphorIconsDuotone.gavel;
  static const signOut = PhosphorIconsDuotone.signOut;
  static const sun = PhosphorIconsDuotone.sun;
  static const moon = PhosphorIconsDuotone.moon;
  static const arrowSquareOut = PhosphorIconsDuotone.arrowSquareOut;
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
    bool solid = false,
  }) : super(
          icon,
          size: size,
          color: color,
          semanticLabel: semanticLabel,
          textDirection: textDirection,
          duotoneSecondaryOpacity: solid ? 1 : 0.20,
        );
}
