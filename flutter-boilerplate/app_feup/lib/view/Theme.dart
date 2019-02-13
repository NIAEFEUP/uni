import 'package:flutter/material.dart';


const Color primaryColor = Color.fromRGBO(140, 45, 25, 1.0);
const Color accentColor = Color.fromRGBO(235, 235, 235, 1.0);
const Color hintColor = Colors.white;


ThemeData applicationTheme = new ThemeData(

  brightness: Brightness.light,
  primaryColor: primaryColor,
  accentColor: accentColor,
  hintColor: hintColor,

  fontFamily: 'Montserrat',

  textTheme: TextTheme(
    headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold, color: primaryColor),
    title: TextStyle(fontSize: 50.0, color: accentColor),
    body1: TextStyle(fontSize: 20.0, color: primaryColor),
  ),
);