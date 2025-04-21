import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// A list of all available icons
class UniIcons {
  static const lecture = PhosphorIconsDuotone.lectern;
  static const exam = PhosphorIconsDuotone.exam;
  static const course = PhosphorIconsDuotone.certificate;
  static const library = PhosphorIconsDuotone.books;
  static const calendar = PhosphorIconsDuotone.calendar;
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

  static const folderOpen = PhosphorIconsDuotone.folderOpen;
  static const folderClosed = PhosphorIconsDuotone.folderSimple;

  static const caretDown = PhosphorIconsDuotone.caretDown;
  static const caretDownRegular = PhosphorIconsRegular.caretDown;
  static const caretUp = PhosphorIconsDuotone.caretUp;
  static const caretRight = PhosphorIconsRegular.caretRight;

  static const file = PhosphorIconsDuotone.file;
  static const fileDoc = PhosphorIconsDuotone.fileDoc;
  static const filePdf = PhosphorIconsDuotone.filePdf;
  static const filePpt = PhosphorIconsDuotone.filePpt;
  static const fileXls = PhosphorIconsDuotone.fileXls;

  static const home = PhosphorIconsDuotone.house;
  static const graduationCap = PhosphorIconsDuotone.graduationCap;
  static const restaurant = PhosphorIconsDuotone.forkKnife;
  static const faculty = PhosphorIconsDuotone.buildings;
  static const map = PhosphorIconsDuotone.mapTrifold;
  static const edit = PhosphorIconsDuotone.pencilSimple;
  static const more = PhosphorIconsDuotone.dotsThreeOutlineVertical;

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

  // Restaurants icons
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
  static const grid = PhosphorIconsDuotone.squaresFour;
  static const list = PhosphorIconsDuotone.listBullets;


  static const island = PhosphorIconsDuotone.island;
  static const beer = PhosphorIconsDuotone.beerStein;

  static const phone = PhosphorIconsDuotone.phone;

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
