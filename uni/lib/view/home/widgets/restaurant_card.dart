import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/meal.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/model/providers/lazy/restaurant_provider.dart';
import 'package:uni/model/utils/day_of_week.dart';
import 'package:uni/utils/drawer_items.dart';
import 'package:uni/view/common_widgets/generic_card.dart';
import 'package:uni/view/common_widgets/request_dependent_widget_builder.dart';
import 'package:uni/view/common_widgets/row_container.dart';
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
      S.of(context).nav_title(DrawerItem.navRestaurants.title);

  @override
  Future<Object?> onClick(BuildContext context) =>
      Navigator.pushNamed(context, '/${DrawerItem.navRestaurants.title}');

  @override
  void onRefresh(BuildContext context) {
    Provider.of<RestaurantProvider>(context, listen: false)
        .forceRefresh(context);
  }

  @override
  Widget buildCardContent(BuildContext context) {
    return LazyConsumer<RestaurantProvider>(
      builder: (context, restaurantProvider) {
        final favoriteRestaurants = restaurantProvider.restaurants
            .where(
              (restaurant) => restaurantProvider.favoriteRestaurants
                  .contains(restaurant.name),
            )
            .toList();
        return RequestDependentWidgetBuilder(
          status: restaurantProvider.status,
          builder: () => generateRestaurants(favoriteRestaurants, context),
          hasContentPredicate: favoriteRestaurants.isNotEmpty,
          onNullContent: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 10),
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
                  '/${DrawerItem.navRestaurants.title}',
                ),
                child: Text(S.of(context).add),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget generateRestaurants(List<Restaurant> data, BuildContext context) {
    final weekDay = DateTime.now().weekday;
    final offset = (weekDay - 1) % 7;
    final restaurants = data;
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: restaurants.length,
      itemBuilder: (BuildContext context, int index) {
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
            padding: const EdgeInsets.fromLTRB(12, 20, 12, 5),
            child: Text(
              restaurant.name,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        if (meals.isNotEmpty)
          Card(
            elevation: 0,
            child: RowContainer(
              borderColor: Colors.transparent,
              color: const Color.fromARGB(0, 0, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: createRestaurantRows(meals, context),
              ),
            ),
          )
        else
          Card(
            elevation: 0,
            child: RowContainer(
              borderColor: Colors.transparent,
              color: const Color.fromARGB(0, 0, 0, 0),
              child: Container(
                padding: const EdgeInsets.fromLTRB(9, 0, 0, 0),
                width: 400,
                child: Text(S.of(context).no_menu_info),
              ),
            ),
          ),
      ],
    );
  }
}

List<Widget> createRestaurantRows(List<Meal> meals, BuildContext context) {
  return meals
      .map((meal) => RestaurantSlot(type: meal.type, name: meal.name))
      .toList();
}
