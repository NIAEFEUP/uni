import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:uni/view/common_widgets/generic_card.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/providers/restaurant_provider.dart';


class RestaurantPageCard extends GenericCard {
  final Restaurant restaurant;
  final Widget meals;

  RestaurantPageCard(this.restaurant, this.meals, {super.key})
      : super.customStyle(editingMode: false, onDelete: () => null, smallTitle: true, cardAction: CardFavoriteButton(restaurant));

  @override
  Widget buildCardContent(BuildContext context) {
    return meals;
  }


  @override
  String getTitle() {
    return restaurant.name;
  }

  @override
  onClick(BuildContext context) {}
}

class CardFavoriteButton extends StatelessWidget {
  final Restaurant restaurant;

  const CardFavoriteButton(this.restaurant, {super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RestaurantProvider>(
        builder: (context, restaurantProvider, _){
          final isFavorite = restaurantProvider.favoriteRestaurants.contains(restaurant.name);
          return IconButton(
              icon: isFavorite ? const Icon(MdiIcons.heart) : const Icon(MdiIcons.heartOutline),
              onPressed: ()  => restaurantProvider.toggleFavoriteRestaurant(restaurant.name, Completer())
          );
        }
    );
  }

}