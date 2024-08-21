import 'package:flutter/material.dart';

abstract class GenericFeatureFlag {
  String get code;
  String getName(BuildContext context);
  bool isEnabled();
  Future<void> setEnabled({required bool enabled});
}
