import 'package:flutter/material.dart';
import 'package:uni_ui/icons.dart';

class RestaurantUtils {
  // Method to get a restaurant related UniIcon based on a specific type
  static UniIcon getIcon(String type, {double size = 24, Color? color}) {
    switch (type) {
      case 'Canteen':
        return const UniIcon(UniIcons.canteen);
      case 'Snack-bar':
        return const UniIcon(UniIcons.snackBar);
      case 'Sopa':
        return const UniIcon(UniIcons.soup);
      case 'Carne':
        return const UniIcon(UniIcons.meat);
      case 'Pescado':
        return const UniIcon(UniIcons.fish);
      case 'Vegetariano':
        return const UniIcon(UniIcons.vegetarian);
      case 'Hortícola':
        return const UniIcon(UniIcons.salad);
      case 'Dieta':
        return const UniIcon(UniIcons.diet);
      default:
        return const UniIcon(UniIcons.restaurant);
    }
  }

  static bool mealMatchesFilter(int? selectedType, String mealType) {
    switch (selectedType) {
      case 1:
        return true;
      case 2:
        return mealType == 'Carne';
      case 3:
        return mealType == 'Pescado';
      case 4:
        return mealType == 'Vegetariano';
      case 5:
        return mealType == 'Sopa';
      case 6:
        return mealType == 'Hortícola';
      case 7:
        return mealType == 'Dieta';
    }
    return false;
  }
}
