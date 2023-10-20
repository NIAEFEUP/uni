import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class RestaurantRow extends StatelessWidget {
  const RestaurantRow({
    required this.local,
    required this.meatMenu,
    required this.fishMenu,
    required this.vegetarianMenu,
    required this.dietMenu,
    super.key,
    this.iconSize = 20.0,
  });
  final String local;
  final String meatMenu;
  final String fishMenu;
  final String vegetarianMenu;
  final String dietMenu;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12, bottom: 8, right: 12),
      margin: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              children: getMenuRows(context),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> getMenuRows(BuildContext context) {
    final widgets = <Widget>[];
    final meals = <String>[meatMenu, fishMenu, vegetarianMenu, dietMenu];
    final mealIcon = <String, IconData>{
      meatMenu: MdiIcons.foodDrumstickOutline,
      fishMenu: MdiIcons.fish,
      vegetarianMenu: MdiIcons.corn,
      dietMenu: MdiIcons.nutrition,
    };

    for (final element in meals) {
      widgets.add(
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 0.7,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(mealIcon[element], size: iconSize),
              Expanded(child: Text(element, textAlign: TextAlign.center)),
            ],
          ),
        ),
      );
    }

    return widgets;
  }
}
