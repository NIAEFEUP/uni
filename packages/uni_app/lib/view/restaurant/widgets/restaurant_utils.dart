import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/app_locale.dart';
import 'package:uni_ui/icons.dart';

class RestaurantUtils {
  // Hour after which to show tomorrow's lunch menu
  static const int lunchSwitchHour = 15;
  // Hour after which to show tomorrow's dinner menu
  static const int dinnerSwitchHour = 21;

  /// Determines if tomorrow's menu should be shown based on current time
  /// and meal period (lunch or dinner)
  /// Returns true if:
  /// - It's after the respective switch hour (15:00 for lunch, 21:00 for dinner)
  /// - It's not Sunday (to avoid showing Monday's menu)
  /// For lunch: switches after 15:00 (3pm)
  /// For dinner: switches after 21:00 (9pm)
  /// If no period is specified, uses dinner switch hour (21:00)
  static bool shouldShowTomorrowMenu(DateTime now, {String? period}) {
    final switchHour = period == 'lunch' ? lunchSwitchHour : dinnerSwitchHour;
    return now.hour >= switchHour && now.weekday != DateTime.sunday;
  }

  // Method to get a restaurant related UniIcon based on a specific type
  static UniIcon getIcon(String? type, {double size = 24, Color? color}) {
    switch (type) {
      case 'Canteen':
        return UniIcon(UniIcons.canteen, size: size, color: color);
      case 'Snack-bar':
        return UniIcon(UniIcons.snackBar, size: size, color: color);
      case 'Sopa':
        return UniIcon(UniIcons.soup, size: size, color: color);
      case 'Carne':
      case 'Prato de Carne':
        return UniIcon(UniIcons.meat, size: size, color: color);
      case 'Pescado':
      case 'Peixe':
      case 'Prato de Peixe':
        return UniIcon(UniIcons.fish, size: size, color: color);
      case 'Vegetariano':
      case 'Prato Vegetariano':
        return UniIcon(UniIcons.vegetarian, size: size, color: color);
      case 'Hortícola':
        return UniIcon(UniIcons.salad, size: size, color: color);
      case 'Dieta':
        return UniIcon(UniIcons.diet, size: size, color: color);
      case 'Prato do Dia':
        return UniIcon(UniIcons.dishOfTheDay, size: size, color: color);
      case 'Encerrado':
        return UniIcon(UniIcons.closed, size: size, color: color);
      default:
        return UniIcon(UniIcons.restaurant, size: size, color: color);
    }
  }

  static String? getMealName(String typeKey) {
    const typeToMealName = <String, String>{
      'meat_dishes': 'Carne',
      'fish_dishes': 'Peixe',
      'vegetarian_dishes': 'Vegetariano',
      'soups': 'Sopa',
      'salads': 'Hortícola',
      'diet_dishes': 'Dieta',
      'dishes_of_the_day': 'Prato do Dia',
      'closed': 'Encerrado',
    };

    return typeToMealName[typeKey];
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
      'closed': ['Encerrado'],
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
      case 'Encerrado':
        return 8;
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
