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

  static bool mealMatchesFilter(Set<String> selectedTypes, String mealType) {
    if (selectedTypes.isEmpty) {
      return true; // If nothing selected, show everything
    }

    final typeToMealNames = <String, List<String>>{
      'meat_dishes': ['Carne', 'Prato de Carne'],
      'fish_dishes': ['Pescado', 'Peixe', 'Prato de Peixe'],
      'vegetarian_dishes': ['Vegetariano', 'Prato Vegetariano'],
      'soups': ['Sopa'],
      'salads': ['Hortícola'],
      'diet_dishes': ['Dieta'],
      'dishes_of_the_day': ['Prato do Dia'],
    };

    for (final type in selectedTypes) {
      if (typeToMealNames[type]?.contains(mealType) ?? false) {
        return true;
      }
    }

    return false;
  }

  static int getMealTypeId(String mealType) {
    switch (mealType) {
      case 'Carne':
      case 'Prato de Carne':
        return 1;
      case 'Pescado':
      case 'Peixe':
      case 'Prato de Peixe':
        return 2;
      case 'Vegetariano':
      case 'Prato Vegetariano':
        return 3;
      case 'Sopa':
        return 4;
      case 'Hortícola':
        return 5;
      case 'Dieta':
        return 6;
      case 'Prato do Dia':
        return 7;
      default:
        return 0;
    }
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
        : '${getLocaleTranslation(locale, portugueseName, englishName)} - ${S.of(context).restaurant_period(period)}';
  }
}
