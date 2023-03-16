import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/providers/restaurant_provider.dart';
import 'package:uni/view/common_widgets/generic_card.dart';
import 'package:uni/view/common_widgets/request_dependent_widget_builder.dart';
import 'package:uni/view/common_widgets/row_container.dart';
import 'package:uni/view/home/widgets/restaurant_row.dart';
import 'package:uni/model/entities/meal.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/model/utils/day_of_week.dart';


final List<DayOfWeek> daysOfTheWeek = [
  DayOfWeek.monday,
  DayOfWeek.tuesday,
  DayOfWeek.wednesday,
  DayOfWeek.thursday,
  DayOfWeek.friday,
  DayOfWeek.saturday,
  DayOfWeek.sunday
];

final int weekDay = DateTime.now().weekday;
final offset = (weekDay > 5) ? 0 : (weekDay - 1) % daysOfTheWeek.length;

class RestaurantCard extends GenericCard {
  RestaurantCard({Key? key}) : super(key: key);

  const RestaurantCard.fromEditingInformation(
      Key key, bool editingMode, Function()? onDelete)
      : super.fromEditingInformation(key, editingMode, onDelete);


  @override
  String getTitle() => 'Cantinas';

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
          onNullContent: Center(
              child: Text('Não existem cantinas para apresentar',
                  style: Theme.of(context).textTheme.headline4,
                  textAlign: TextAlign.center)));});
  }


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
            createRowFromRestaurant(context, restaurants[index], daysOfTheWeek[offset])
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
              padding: const EdgeInsets.all(12.0), child: Text(restaurant.name))),
      Card(
        elevation: 1,
        child: RowContainer(
            color: const Color.fromARGB(0, 0, 0, 0),
            child: RestaurantRow(
              local: restaurant.name,
              meatMenu: meals.isNotEmpty ? meals[0].name : 'Prato não disponível',
              fishMenu: meals.length > 1 ? meals[1].name : 'Prato não disponível',
              vegetarianMenu: meals.length > 2 ? meals[2].name : 'Prato não disponível',
              dietMenu: meals.length > 3 ? meals[3].name : 'Prato não disponível',
            )),
      ),
    ]);
  }
}
