import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RestaurantSlot extends StatelessWidget {
  const RestaurantSlot({
    required this.type,
    required this.name,
    super.key,
  });
  final String type;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 22),
      child: Container(
        key: Key('cantine-slot-type-$type'),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 8, 0),
              child: SizedBox(
                width: 20,
                child: RestaurantSlotType(type: type),
              ),
            ),
            Flexible(
              child: Text(
                name,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RestaurantSlotType extends StatelessWidget {
  const RestaurantSlotType({required this.type, super.key});
  final String type;

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
    final icon = getIcon();
    return Tooltip(
      message: type,
      child: icon != ''
          ? SvgPicture.asset(
              icon,
              colorFilter: ColorFilter.mode(
                Theme.of(context).primaryColor,
                BlendMode.srcIn,
              ),
              height: 20,
            )
          : null,
    );
  }

  String getIcon() => mealTypeIcons.entries
      .firstWhere(
        (element) => type.toLowerCase().contains(element.key),
        orElse: () => const MapEntry('', ''),
      )
      .value;
}
