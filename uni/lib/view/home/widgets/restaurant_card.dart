import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/meal.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/model/providers/lazy/restaurant_provider.dart';
import 'package:uni/model/utils/day_of_week.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/common_widgets/generic_card.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni/view/restaurant/widgets/restaurant_slot.dart';

class RestaurantCard extends GenericCard {
  RestaurantCard({super.key});

  const RestaurantCard.fromEditingInformation(
    super.key, {
    required super.editingMode,
    super.onDelete,
  }) : super.fromEditingInformation();

  @override
  String getTitle(BuildContext context) =>
      S.of(context).nav_title(NavigationItem.navRestaurants.route);

  @override
  Future<Object?> onClick(BuildContext context) =>
      Navigator.pushNamed(context, '/${NavigationItem.navRestaurants.route}');

  @override
  void onRefresh(BuildContext context) {
    Provider.of<RestaurantProvider>(context, listen: false)
        .forceRefresh(context);
  }

  @override
  Widget buildCardContent(BuildContext context) {
    return LazyConsumer<RestaurantProvider, List<Restaurant>>(
      builder: (context, restaurants) {
        final favoriteRestaurants = restaurants
            .where(
              (restaurant) => PreferencesController.getFavoriteRestaurants()
                  .contains(restaurant.name),
            )
            .toList();
        return generateRestaurants(favoriteRestaurants, context);
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

  Widget generateRestaurants(
    List<Restaurant> restaurants,
    BuildContext context,
  ) {
    final weekDay = DateTime.now().weekday;
    final offset = (weekDay - 1) % 7;

    if (restaurants
        .map((e) => e.meals[DayOfWeek.values[offset]])
        .every((element) => element?.isEmpty ?? true)) {
      return Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Text(
            S.of(context).no_menus,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: restaurants.length,
      itemBuilder: (context, index) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            createRowFromRestaurant(
              context,
              restaurants[index],
              DayOfWeek.values[offset],
            ),
          ],
        );
      },
    );
  }

  Widget createRowFromRestaurant(
    BuildContext context,
    Restaurant restaurant,
    DayOfWeek day,
  ) {
    final meals = restaurant.getMealsOfDay(day);
    return Column(
      children: [
        Center(
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(10, 15, 5, 10),
            child: Text(
              restaurant.name,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        if (meals.isNotEmpty)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: createRestaurantRows(meals, context),
          )
        else
          Container(
            padding: const EdgeInsets.fromLTRB(9, 0, 0, 0),
            width: 400,
            child: Text(S.of(context).no_menu_info),
          ),
        const SizedBox(height: 10),
      ],
    );
  }
}

List<Widget> createRestaurantRows(List<Meal> meals, BuildContext context) {
  return meals
      .map((meal) => RestaurantSlot(type: meal.type, name: meal.name))
      .toList();
}
