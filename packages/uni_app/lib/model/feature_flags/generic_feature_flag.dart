import 'package:flutter/material.dart';

abstract class GenericFeatureFlag {
  String get code;
  String getName(BuildContext context);
  bool get enabled;
  set enabled(bool enabled);
}
