import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/app_locale.dart';
import 'package:uni_ui/icons.dart';

class RestaurantUtils {
  // Method to get a restaurant related UniIcon based on a specific type
  static UniIcon getIcon(String? type, {double size = 24, Color? color}) {
    switch (type) {
      case 'Canteen':
        return const UniIcon(UniIcons.canteen);
      case 'Snack-bar':
        return const UniIcon(UniIcons.snackBar);
      case 'Sopa':
        return const UniIcon(UniIcons.soup);
      case 'Carne':
      case 'Prato de Carne':
        return const UniIcon(UniIcons.meat);
      case 'Pescado':
      case 'Peixe':
      case 'Prato de Peixe':
        return const UniIcon(UniIcons.fish);
      case 'Vegetariano':
      case 'Prato Vegetariano':
        return const UniIcon(UniIcons.vegetarian);
      case 'Hortícola':
        return const UniIcon(UniIcons.salad);
      case 'Dieta':
        return const UniIcon(UniIcons.diet);
      case 'Prato do Dia':
        return const UniIcon(UniIcons.dishOfTheDay);
      default:
        return const UniIcon(UniIcons.restaurant);
    }
  }

  static bool mealMatchesFilter(Set<int> selectedTypes, String mealType) {
    if (selectedTypes.isEmpty) {
      return true; // If nothing selected, show everything
    }

    if (selectedTypes.contains(1) &&
        ['Carne', 'Prato de Carne'].contains(mealType)) {
      return true;
    }

    if (selectedTypes.contains(2) &&
        ['Pescado', 'Peixe', 'Prato de Peixe'].contains(mealType)) {
      return true;
    }

    if (selectedTypes.contains(3) &&
        ['Vegetariano', 'Prato Vegetariano'].contains(mealType)) {
      return true;
    }

    if (selectedTypes.contains(4) && ['Sopa'].contains(mealType)) {
      return true;
    }

    if (selectedTypes.contains(5) && ['Hortícola'].contains(mealType)) {
      return true;
    }

    if (selectedTypes.contains(6) && ['Dieta'].contains(mealType)) {
      return true;
    }

    if (selectedTypes.contains(7) && ['Prato do Dia'].contains(mealType)) {
      return true;
    }

    return false;
  }

  static String getLocaleTranslation(
    AppLocale locale,
    String portugueseTranslation,
    String englishTranslation,
  ) {
    return locale == AppLocale.pt ? portugueseTranslation : englishTranslation;
  }

  static String getRestaurantName(
    BuildContext context,
    AppLocale locale,
    String portugueseName,
    String englishName,
    String period,
  ) {
    final translatedPeriod = S.of(context).restaurant_period(period);
    return translatedPeriod == 'Other'
        ? getLocaleTranslation(locale, portugueseName, englishName)
        : '${getLocaleTranslation(
            locale,
            portugueseName,
            englishName,
          )} - ${S.of(context).restaurant_period(period)}';
  }
}
