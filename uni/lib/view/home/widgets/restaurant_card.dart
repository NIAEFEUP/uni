import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/model/providers/lazy/restaurant_provider.dart';
import 'package:uni/view/common_widgets/date_rectangle.dart';
import 'package:uni/view/common_widgets/generic_card.dart';
import 'package:uni/view/common_widgets/request_dependent_widget_builder.dart';
import 'package:uni/view/common_widgets/row_container.dart';
import 'package:uni/view/home/widgets/restaurant_row.dart';
import 'package:uni/view/lazy_consumer.dart';

class RestaurantCard extends GenericCard {
  RestaurantCard({super.key});

  const RestaurantCard.fromEditingInformation(
    super.key, {
    required super.editingMode,
    super.onDelete,
  }) : super.fromEditingInformation();

  @override
  String getTitle(BuildContext context) => 'Cantinas';

  @override
  void onClick(BuildContext context) {}

  @override
  void onRefresh(BuildContext context) {
    Provider.of<RestaurantProvider>(context, listen: false)
        .forceRefresh(context);
  }

  @override
  Widget buildCardContent(BuildContext context) {
    return LazyConsumer<RestaurantProvider>(
      builder: (context, restaurantProvider) => RequestDependentWidgetBuilder(
        status: restaurantProvider.status,
        builder: () =>
            generateRestaurant(restaurantProvider.restaurants, context),
        hasContentPredicate: restaurantProvider.restaurants.isNotEmpty,
        onNullContent: Center(
          child: Text(
            'Não existem cantinas para apresentar',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget generateRestaurant(
    UnmodifiableListView<Restaurant> canteens,
    BuildContext context,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [createRowFromRestaurant(context, canteens.toString())],
    );
  }

  Widget createRowFromRestaurant(BuildContext context, String canteen) {
    return Column(
      children: [
        const DateRectangle(date: ''),
        // cantine.nextSchoolDay
        Center(
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Text(canteen),
          ),
        ),
        Card(
          elevation: 1,
          child: RowContainer(
            color: const Color.fromARGB(0, 0, 0, 0),
            child: RestaurantRow(
              local: canteen,
              meatMenu: '',
              fishMenu: '',
              vegetarianMenu: '',
              dietMenu: '',
            ),
          ),
        ),
      ],
    );
  }
}
