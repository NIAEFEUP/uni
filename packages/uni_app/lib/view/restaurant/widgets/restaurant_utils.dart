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

  static bool mealMatchesFilter(int? selectedType, String mealType) {
    switch (selectedType) {
      case 1:
        return ['Carne', 'Prato de Carne'].contains(mealType);
      case 2:
        return ['Pescado', 'Peixe', 'Prato de Peixe'].contains(mealType);
      case 3:
        return ['Vegetariano', 'Prato Vegetariano'].contains(mealType);
      case 4:
        return ['Sopa'].contains(mealType);
      case 5:
        return ['Hortícola'].contains(mealType);
      case 6:
        return ['Dieta'].contains(mealType);
      case 7:
        return ['Prato do Dia'].contains(mealType);
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
