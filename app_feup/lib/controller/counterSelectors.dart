library HomePageController;

import 'dart:math';
import 'package:flutter/material.dart';

Color getColorFromValue(value){
  return new Color.fromRGBO(min(max(value*2, 50),255) , max(180 - value*2, 0), max(128 - value*2, 0), 1.0);
}