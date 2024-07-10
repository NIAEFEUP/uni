import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';

Map<String, String Function()> generateFeatureFlagTable(BuildContext context) {
  return {
    'library_modules': () => S.of(context).library_modules,
  };
}
