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

  static const mealTypeIcons = {
    'sopa': 'assets/meal-icons/soup.svg',
    'carne': 'assets/meal-icons/chicken.svg',
    'peixe': 'assets/meal-icons/fish.svg',
    'dieta': 'assets/meal-icons/diet.svg',
    'vegetariano': 'assets/meal-icons/vegetarian.svg',
    'salada': 'assets/meal-icons/salad.svg',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.fromLTRB(9, 3.5, 0, 3.5),
      child: Container(
          key: Key('cantine-slot-type-$type'),
          child: Row(
            children: [
              Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 8.0, 0),
                  child: SizedBox(
                    width: 20,
                    child: createCanteenSlotType(context),
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

  Widget createCanteenSlotType(context) {
    final mealsType = type.toLowerCase();

    final icon = mealTypeIcons.entries
        .firstWhere((element) => mealsType.contains(element.key),
            orElse: () => const MapEntry('', ''))
        .value;

    return Tooltip(
        message: type,
        child: icon != ''
            ? SvgPicture.asset(
                icon,
                color: Theme.of(context).primaryColor,
                height: 20,
              )
            : null);
  }
}
