import 'package:flutter/material.dart';
import 'package:uni/model/providers/restaurant_provider.dart';
import 'package:uni/view/common_widgets/date_rectangle.dart';
import 'package:uni/view/common_widgets/generic_card.dart';
import 'package:uni/view/common_widgets/request_dependent_widget_builder.dart';
import 'package:uni/view/common_widgets/row_container.dart';
import 'package:uni/view/home/widgets/restaurant_row.dart';
import 'package:uni/view/lazy_consumer.dart';

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
    return LazyConsumer<RestaurantProvider>(
        builder: (context, restaurantProvider, _) =>
            RequestDependentWidgetBuilder(
                context: context,
                status: restaurantProvider.status,
                contentGenerator: generateRestaurant,
                content: restaurantProvider.restaurants,
                contentChecker: restaurantProvider.restaurants.isNotEmpty,
                onNullContent: Center(
                    child: Text('Não existem cantinas para apresentar',
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center))));
  }

  Widget generateRestaurant(canteens, context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [createRowFromRestaurant(context, canteens)],
    );
  }

  Widget createRowFromRestaurant(context, String canteen) {
    // TODO: Issue #390
    return Column(children: [
      const DateRectangle(date: ''), // TODO: Issue #390
      // cantine.nextSchoolDay
      Center(
          child: Container(
              padding: const EdgeInsets.all(12.0), child: Text(canteen))),
      Card(
        elevation: 1,
        child: RowContainer(
            color: const Color.fromARGB(0, 0, 0, 0),
            child: RestaurantRow(
              local: canteen,
              meatMenu: '',
              // TODO: Issue #390
              fishMenu: '',
              vegetarianMenu: '',
              dietMenu: '',
            )),
      ),
    ]);
  }
}
