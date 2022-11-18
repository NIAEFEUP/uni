import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class RestaurantRow extends StatelessWidget {
  final String local;
  final String meatMenu;
  final String fishMenu;
  final String vegetarianMenu;
  final String dietMenu;
  final double iconSize;

  const RestaurantRow({
    Key? key,
    required this.local,
    required this.meatMenu,
    required this.fishMenu,
    required this.vegetarianMenu,
    required this.dietMenu,
    this.iconSize = 20.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12.0, bottom: 8.0, right: 12),
      margin: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: Column(
            children: getMenuRows(context),
          ))
        ],
      ),
    );
  }

  List<Widget> getMenuRows(BuildContext context) {
    final List<Widget> widgets = [];
    final List<String> meals = [meatMenu, fishMenu, vegetarianMenu, dietMenu];
    final Map<String, IconData> mealIcon = {
      meatMenu: MdiIcons.foodDrumstickOutline,
      fishMenu: MdiIcons.fish,
      vegetarianMenu: MdiIcons.corn,
      dietMenu: MdiIcons.nutrition
    };

    for (var element in meals) {
      widgets.add(Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 0.7,
                      color: Theme.of(context).colorScheme.secondary))),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(mealIcon[element], size: iconSize),
                Expanded(child: Text(element, textAlign: TextAlign.center)),
              ])));
    }

    return widgets;
  }
}
