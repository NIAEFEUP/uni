import 'package:flutter/material.dart';
import 'package:uni/view/common_widgets/row_container.dart';
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
        child: Container(
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
    ));
  }

  Widget createCantineSlotType(context) {
    if(type.contains("Carne")) {
      return SvgPicture.asset(
        color: Theme.of(context).primaryColor,
        'assets/icons-cantine/chicken.svg',
        height: 20,
      );
    } if (type.contains("Peixe")) {
      return SvgPicture.asset(
        color: Theme.of(context).primaryColor,
        'assets/icons-cantine/fish.svg',
        height: 20,
      );
    } if (type.contains("Vegetariano")) {
      return SvgPicture.asset(
        color: Theme.of(context).primaryColor,
        'assets/icons-cantine/salad.svg',
        height: 20,
      );
    } if (type.contains("Dieta")) {
      return SvgPicture.asset(
        color: Theme.of(context).primaryColor,
        'assets/icons-cantine/diet.svg',
        height: 20,
      );
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
