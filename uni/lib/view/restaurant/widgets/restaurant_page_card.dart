import 'package:flutter/material.dart';
import 'package:uni/view/common_widgets/generic_card.dart';

class RestaurantPageCard extends GenericCard {
  RestaurantPageCard(this.restaurantName, this.meals, {super.key})
      : super.customStyle(
          editingMode: false,
          onDelete: () {},
          hasSmallTitle: true,
        );
  final String restaurantName;
  final Widget meals;

  @override
  Widget buildCardContent(BuildContext context) {
    return meals;
  }

  @override
  String getTitle(BuildContext context) {
    return restaurantName;
  }

  @override
  void onClick(BuildContext context) {}

  @override
  void onRefresh(BuildContext context) {}
}
