import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RestaurantSlot extends StatelessWidget {
  final String type;
  final String name;

  const RestaurantSlot({
    Key? key,
    required this.type,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(9, 3.5, 0, 3.5),
      child: Container(
          key: Key('cantine-slot-type-$type'),
          child: Row(
            children: [
              Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 8.0, 0),
                  child: SizedBox(
                    width: 20,
                    child: RestaurantSlotType(type: type),
                  )),
              Flexible(
                  child: Text(
                name,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.left,
              ))
            ],
          )),
    );
  }
}

class RestaurantSlotType extends StatelessWidget {
  final String type;

  static const mealTypeIcons = {
    'sopa': 'assets/meal-icons/soup.svg',
    'carne': 'assets/meal-icons/chicken.svg',
    'peixe': 'assets/meal-icons/fish.svg',
    'dieta': 'assets/meal-icons/diet.svg',
    'vegetariano': 'assets/meal-icons/vegetarian.svg',
    'salada': 'assets/meal-icons/salad.svg',
  };

  const RestaurantSlotType({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String icon = getIcon();
    return Tooltip(
        message: type,
        child: icon != ''
            ? SvgPicture.asset(
                icon,
                colorFilter: ColorFilter.mode(
                    Theme.of(context).primaryColor, BlendMode.srcIn),
                height: 20,
              )
            : null);
  }

  String getIcon() => mealTypeIcons.entries
      .firstWhere((element) => type.toLowerCase().contains(element.key),
          orElse: () => const MapEntry('', ''))
      .value;
}
