import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CantineSlot extends StatelessWidget {
  final String type;
  final String name;

  const CantineSlot({
    Key? key,
    required this.type,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
      top: 10.0, bottom: 10.0, left: 22.0, right: 22.0),
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

    if(mealsType.contains("carne")) {
      return Tooltip(
          message: 'Prato de carne',
          child: SvgPicture.asset(
        color: Theme.of(context).primaryColor,
        'assets/icons-cantines/chicken.svg',
        height: 20,
      ));
    } if (mealsType.contains("peixe")) {
      return Tooltip(
          message: 'Prato de peixe',
          child: SvgPicture.asset(
        color: Theme.of(context).primaryColor,
        'assets/icons-cantines/fish.svg',
        height: 20,
      ));
    } if (mealsType.contains("vegetariano")) {
      return Tooltip(
        message: 'Prato Vegetariano',
        child: SvgPicture.asset(
        color: Theme.of(context).primaryColor,
        'assets/icons-cantines/salad.svg',
        height: 20,
      ));
    } if (mealsType.contains("dieta")) {
      return Tooltip(
          message: 'Prato de Dieta',
          child: SvgPicture.asset(
        color: Theme.of(context).primaryColor,
        'assets/icons-cantines/diet.svg',
        height: 20,
      ));
    } else {
      return
        Text(type,
          style: const TextStyle(
            fontSize: 20
          ),
        );
    }

  }
}
