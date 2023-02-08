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
      padding: const EdgeInsets.only(
      top: 10.0, bottom: 10.0, left: 10, right: 22.0),
      child: Container(
      key: Key('cantine-slot-type-$type'),
      child: Row(

        children: [
          Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 8.0, 0),
              child: SizedBox(
                width: 20,
                child: createCantineSlotType(context),
              )),Flexible(
              child: Text(
                name,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.left,
              )
          )
        ],
      )),
    );
  }

  Widget createCantineSlotType(context) {
    final mealsType = type.toLowerCase();

    String icon;
    if (mealsType.contains("carne")) {icon = 'assets/icons-cantines/chicken.svg';}
    else if (mealsType.contains("peixe")) {icon = 'assets/icons-cantines/fish.svg';}
    else if (mealsType.contains("vegetariano")) {icon = 'assets/icons-cantines/salad.svg';}
    else if (mealsType.contains("dieta")) {icon = 'assets/icons-cantines/diet.svg';}
    else {icon = '';}

    return Tooltip(
      message: type,
        child: SvgPicture.asset(
      color: Theme.of(context).primaryColor,
      icon,
      height: 20,
    ));

  }

}
