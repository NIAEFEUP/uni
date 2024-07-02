import 'package:flutter/material.dart';

enum AppLocale {
  en,
  pt;

  Locale get localeCode {
    switch (this) {
      case AppLocale.en:
        return const Locale('en');
      case AppLocale.pt:
        return const Locale('pt');
    }
  }
}
