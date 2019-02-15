import 'package:flutter/material.dart';


const Color primaryColor = Color.fromRGBO(79, 19, 21, 1.0);
const Color accentColor = Color.fromRGBO(192, 55, 54, 1.0);


ThemeData applicationTheme = new ThemeData(

  brightness: Brightness.light,
  primaryColor: primaryColor,
  accentColor: accentColor,

  fontFamily: 'Montserrat',

  textTheme: TextTheme(
    headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold, color: primaryColor),
    title: TextStyle(fontSize: 36.0, color: accentColor),
    body1: TextStyle(fontSize: 18.0, color: primaryColor),
  ),
);