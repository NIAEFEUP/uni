import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/model/entities/app_locale.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/model/providers/lazy/restaurant_provider.dart';
import 'package:uni/model/utils/day_of_week.dart';
import 'package:uni/view/home/widgets2/generic_home_card.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni/view/locale_notifier.dart';
import 'package:uni/view/restaurant/widgets/restaurant_utils.dart';
import 'package:uni_ui/cards/restaurant_card.dart';
import 'package:uni_ui/cards/widgets/restaurant_menu_item.dart';

class RestaurantHomeCard extends GenericHomecard {
  const RestaurantHomeCard({super.key, super.title = 'Restaurants'});

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

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: CarouselView(
                  itemSnapping: true,
                  itemExtent: double.infinity,
                  children: [
                    ...getRestaurantInformation(context, favoriteRestaurants),
                  ],
                ),
              ),
            ],
          );
        },
        hasContent: (restaurants) => restaurants.isNotEmpty,
        onNullContent: const Text("Sem restaurantes favoritos"));
  }

  List<RestaurantCard> getRestaurantInformation(
    BuildContext context,
    List<Restaurant> favoriteRestaurants,
  ) {
    final locale = Provider.of<LocaleNotifier>(context).getLocale();

    final today = parseDateTime(DateTime.now());

    final restaurantsWidgets = favoriteRestaurants
        .where((element) => element.meals[today]?.isNotEmpty ?? false)
        .map((restaurant) {
      final menuItems = getRestaurantMenuItems(today, restaurant, locale) ?? [];
      return RestaurantCard(
        name: RestaurantUtils.getRestaurantName(
          context,
          locale,
          restaurant.namePt,
          restaurant.namePt,
          restaurant.period,
        ),
        icon: RestaurantUtils.getIcon(
          restaurant.typeEn ?? restaurant.typePt,
        ),
        isFavorite: PreferencesController.getFavoriteRestaurants()
            .contains(restaurant.namePt + restaurant.period),
        onFavoriteToggle: () => {},
        menuItems: menuItems,
      );
    }).toList();

    return restaurantsWidgets;
  }

  List<RestaurantMenuItem>? getRestaurantMenuItems(
    DayOfWeek dayOfWeek,
    Restaurant restaurant,
    AppLocale locale,
  ) {
    final meals = restaurant.meals[dayOfWeek];

    meals?.sort((a, b) => a.type.compareTo(b.type));

    final menuItems = <RestaurantMenuItem>[];
    for (final meal in meals!) {
      menuItems.add(
        RestaurantMenuItem(
          name: RestaurantUtils.getLocaleTranslation(
            locale,
            meal.namePt,
            meal.nameEn,
          ),
          icon: RestaurantUtils.getIcon(meal.type),
        ),
      );
    }
    return menuItems;
  }
}
