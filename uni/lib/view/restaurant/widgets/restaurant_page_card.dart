import 'package:flutter/material.dart';
import 'package:uni/view/common_widgets/generic_card.dart';

class RestaurantPageCard extends GenericCard {
  final String restaurantName;
  final Widget meals;

  RestaurantPageCard(this.restaurantName, this.meals, {super.key})
      : super.customStyle(
            editingMode: false, onDelete: () => null, smallTitle: true);

  @override
  Widget buildCardContent(BuildContext context) {
    return meals;
  }

  @override
  String getTitle() {
    return restaurantName;
  }

  @override
  onClick(BuildContext context) {}
}
