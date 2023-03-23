import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/providers/restaurant_provider.dart';
import 'package:uni/view/common_widgets/generic_card.dart';
import 'package:uni/view/common_widgets/request_dependent_widget_builder.dart';
import 'package:uni/view/common_widgets/row_container.dart';
import 'package:uni/model/entities/meal.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/model/utils/day_of_week.dart';
import 'package:uni/utils/drawer_items.dart';
import 'package:uni/view/restaurant/widgets/restaurant_slot.dart';

final int weekDay = DateTime.now().weekday;
final offset = (weekDay > 5) ? 0 : (weekDay - 1) % DayOfWeek.values.length;

class RestaurantCard extends GenericCard {
  RestaurantCard({Key? key}) : super(key: key);

  const RestaurantCard.fromEditingInformation(
      Key key, bool editingMode, Function()? onDelete)
      : super.fromEditingInformation(key, editingMode, onDelete);

  @override
  String getTitle() => 'Restaurantes';

  @override
  onClick(BuildContext context) => null;

  @override
  Widget buildCardContent(BuildContext context) {
    return Consumer<RestaurantProvider>(builder: (context, restaurantProvider, _) {
      final List<Restaurant> favoriteRestaurants = restaurantProvider.restaurants.where((restaurant) => restaurantProvider.favoriteRestaurants.contains(restaurant.name)).toList();
      return RequestDependentWidgetBuilder(
          context: context,
          status: restaurantProvider.status,
          contentGenerator: generateRestaurant,
          content: favoriteRestaurants,
          contentChecker: favoriteRestaurants.isNotEmpty,
          onNullContent: Column(children: [
                            Padding(
                                padding: const EdgeInsets.only(top: 15, bottom: 10),
                                child: Center(
                                  child: Text('Sem restaurantes favoritos',
                                  style: Theme.of(context).textTheme.subtitle1))),
                                  OutlinedButton(
                                    onPressed: () => Navigator.pushNamed(context, '/${DrawerItem.navRestaurants.title}'),
                                    child: const Text('Adicionar'))
      ]));
  });}


  Widget generateRestaurant(dynamic data, BuildContext context) {
    final List<Restaurant> restaurants = data;
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: restaurants.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            createRowFromRestaurant(context, restaurants[index], DayOfWeek.values[offset])
          ],
        );
      },
    );
  }


  Widget createRowFromRestaurant(context, Restaurant restaurant, DayOfWeek day) {
    final List<Meal> meals = restaurant.getMealsOfDay(day);
    return Column(children: [
      Center(
          child: Container(
              padding: const EdgeInsets.all(15.0), child: Text(restaurant.name)),),
      if(meals.isNotEmpty)
      Card(
        elevation: 1,
        child: RowContainer(
            color: const Color.fromARGB(0, 0, 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: createRestaurantRows(meals, context),
            )),
      )
      else
      Card(
        elevation: 1,
        child: RowContainer(
            color: const Color.fromARGB(0, 0, 0, 0),
            child: Container(
              padding: const EdgeInsets.all(12.0),
              child: const SizedBox(
                width: 400,
                child: Text("Não há refeições disponíveis", textAlign: TextAlign.center),
              ))
            ))
    ]);
  }

  List<Widget> createRestaurantRows(List<Meal> meals, BuildContext context) {
    return meals
        .map((meal) => RestaurantSlot(type: meal.type, name: meal.name))
        .toList();
  }

}
