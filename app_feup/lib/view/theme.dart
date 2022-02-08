import 'package:flutter/material.dart';

const Color _darkRed = Color.fromARGB(255, 0x75, 0x17, 0x1e);
const Color _lightRed = Color.fromARGB(255, 190, 40, 40);
const Color _mildWhite = Color.fromARGB(255, 0xfa, 0xfa, 0xfa);
const Color _lightGrey = Color.fromARGB(255, 215, 215, 215);
const Color _grey = Color.fromARGB(255, 0x7f, 0x7f, 0x7f);
const Color _strongGrey = Color.fromARGB(255, 90, 90, 90);
const Color _mildBlack = Color.fromARGB(255, 0x30, 0x30, 0x30);

ThemeData applicationLightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.white,
    accentColor: _darkRed,
    dividerColor: _lightGrey,
    hintColor: _lightGrey,
    backgroundColor: _mildWhite,
    scaffoldBackgroundColor: _mildWhite,
    textTheme: TextTheme(
      headline1: TextStyle(
          fontSize: 72.0, fontWeight: FontWeight.bold, color: _darkRed),
      headline2: TextStyle(
          fontSize: 17.0, color: _mildBlack, fontWeight: FontWeight.w300),
      headline3: TextStyle(
          fontSize: 17.0, color: _lightRed, fontWeight: FontWeight.w300),
      headline4: TextStyle(
          fontSize: 17.0, color: _mildBlack, fontWeight: FontWeight.w300),
      headline5: TextStyle(
          fontSize: 17.0, color: _mildBlack, fontWeight: FontWeight.w400),
      headline6: TextStyle(
          fontSize: 17.0, color: _mildBlack, fontWeight: FontWeight.w300),
      subtitle1:
          TextStyle(fontSize: 17.0, color: _grey, fontWeight: FontWeight.w300),
      subtitle2:
          TextStyle(fontSize: 16.0, color: _grey, fontWeight: FontWeight.w300),
      bodyText1: TextStyle(fontSize: 16.0, color: _mildBlack),
      bodyText2: TextStyle(fontSize: 15.0, color: _mildBlack),
      caption:
          TextStyle(fontSize: 12.0, color: _grey, fontWeight: FontWeight.w500),
    ),
    iconTheme: IconThemeData(color: _strongGrey),
    unselectedWidgetColor: _grey,
    toggleableActiveColor: _darkRed,
    tabBarTheme: TabBarTheme(
      unselectedLabelColor: _strongGrey,
      labelColor: _strongGrey,
      labelPadding: EdgeInsets.all(0.0),
    ),
    canvasColor: _mildWhite,
    cardColor: Colors.white,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          primary: _darkRed,
          padding: const EdgeInsets.all(10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 15.0)),
    ),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            primary: _darkRed,
            textStyle: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400))),
    checkboxTheme: CheckboxThemeData(
        checkColor: MaterialStateProperty.all(Colors.white),
        fillColor: MaterialStateColor.resolveWith(
          (states) {
            if (states.contains(MaterialState.selected)) {
              return _darkRed; // the color when checkbox is selected;
            }
            return _grey; //the color when checkbox is unselected;
          },
        )));

ThemeData applicationDarkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: _strongGrey,
    accentColor: Colors.white,
    dividerColor: _lightGrey,
    hintColor: _lightGrey,
    backgroundColor: _mildBlack,
    scaffoldBackgroundColor: _mildBlack,
    textTheme: TextTheme(
      headline1: TextStyle(
          fontSize: 72.0, fontWeight: FontWeight.bold, color: Colors.white),
      headline2: TextStyle(
          fontSize: 17.0, color: Colors.white, fontWeight: FontWeight.w300),
      headline3: TextStyle(
          fontSize: 17.0, color: Colors.white, fontWeight: FontWeight.w300),
      headline4: TextStyle(
          fontSize: 17.0, color: Colors.white, fontWeight: FontWeight.w300),
      headline5: TextStyle(
          fontSize: 17.0, color: Colors.white, fontWeight: FontWeight.w400),
      headline6: TextStyle(
          fontSize: 17.0, color: Colors.white, fontWeight: FontWeight.w300),
      subtitle1: TextStyle(
          fontSize: 17.0, color: Colors.white, fontWeight: FontWeight.w300),
      subtitle2: TextStyle(
          fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.w300),
      bodyText1: TextStyle(fontSize: 16.0, color: Colors.white),
      bodyText2: TextStyle(fontSize: 15.0, color: Colors.white),
      caption: TextStyle(
          fontSize: 12.0, color: Colors.white, fontWeight: FontWeight.w500),
    ),
    iconTheme: IconThemeData(color: Colors.white),
    unselectedWidgetColor: _grey,
    toggleableActiveColor: Colors.white,
    tabBarTheme: TabBarTheme(
      unselectedLabelColor: Colors.white,
      labelColor: Colors.white,
      labelPadding: EdgeInsets.all(0.0),
    ),
    canvasColor: _mildBlack,
    cardColor: Colors.white,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          primary: Colors.white,
          padding: const EdgeInsets.all(10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          textStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: 15.0)),
    ),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            primary: Colors.white,
            textStyle: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400))),
    checkboxTheme: CheckboxThemeData(
        checkColor: MaterialStateProperty.all(Colors.white),
        fillColor: MaterialStateColor.resolveWith(
          (states) {
            if (states.contains(MaterialState.selected)) {
              return _darkRed; // the color when checkbox is selected;
            }
            return _grey; //the color when checkbox is unselected;
          },
        )));

ThemeData applicationPureDarkTheme =
    applicationDarkTheme.copyWith(scaffoldBackgroundColor: Colors.black);
