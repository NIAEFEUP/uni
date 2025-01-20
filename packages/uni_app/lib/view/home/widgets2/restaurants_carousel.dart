import 'package:flutter/material.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/model/providers/lazy/restaurant_provider.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/home/widgets2/generic_home_card.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni_ui/cards/restaurant_card.dart';

class RestaurantsCarousel extends GenericHomecard {
  const RestaurantsCarousel({
    super.key,
    required super.title,
  });

  @override
  void onClick(BuildContext context) => {};

  @override
  Widget buildCardContent(BuildContext context) {
    return LazyConsumer<RestaurantProvider, List<Restaurant>>(
      builder: (context, restaurants) {
        final favoriteRestaurants = restaurants
            .where(
              (restaurant) => PreferencesController.getFavoriteRestaurants()
                  .contains(restaurant.namePt + restaurant.period),
            )
            .toList();
        return Container(); // TODO: finish this once restaurants page is complete
      },
      hasContent: (restaurants) =>
          PreferencesController.getFavoriteRestaurants().isNotEmpty,
      onNullContent: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Center(
              child: Text(
                S.of(context).no_favorite_restaurants,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          OutlinedButton(
            onPressed: () => Navigator.pushNamed(
              context,
              '/${NavigationItem.navRestaurants.route}',
            ),
            child: Text(S.of(context).add),
          ),
        ],
      ),
    );
  }
}
