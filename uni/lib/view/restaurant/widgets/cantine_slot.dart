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
    return RowContainer(
        child: Container(
      padding: const EdgeInsets.only(
          top: 10.0, bottom: 10.0, left: 22.0, right: 22.0),
      child: createCantineSlotRow(context),
    ));
  }

  Widget createCantineSlotRow(context) {
    return Container(
        key: Key('cantine-slot-type-$type'),
        child: Row(

          children: createCantineSlotPrimInfo(context),
        ));
  }

  Widget createCantineSlotType(context) {

    if(type == "Carne" || type == "Prato de Carne") {
      return SvgPicture.asset(
        color: Theme.of(context).primaryColor,
        'assets/icons-cantine/chicken.svg',
        height: 20,
      );
    } else if (type == "Peixe" || type == "Prato de Peixe") {
      return SvgPicture.asset(
        color: Theme.of(context).primaryColor,
        'assets/icons-cantine/fish.svg',
        height: 20,
      );
    } else if (type == "Vegetariano" || type == "Prato Vegetariano") {
      return SvgPicture.asset(
        color: Theme.of(context).primaryColor,
        'assets/icons-cantine/salad.svg',
        height: 20,
      );
    } else if (type == "Dieta") {
      return SvgPicture.asset(
        color: Theme.of(context).primaryColor,
        'assets/icons-cantine/diet.svg',
        height: 20,
      );
    } else {
      return
        Text(type,
          style: const TextStyle(
            color: Colors.red,
            fontSize: 20
          ),
        );
    }

  }

  Widget createCantineType(String type, context) => createTextField(
      type,
      Theme.of(context).textTheme.bodyMedium,
      TextAlign.left);

  List<Widget> createCantineSlotPrimInfo(context) {
    return [
      Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 8.0, 0),
          child: SizedBox(
        width: 20,
      child: createCantineSlotType(context),
      )),Flexible(
        child: createTextField(
            name ,
            Theme.of(context).textTheme.bodyMedium,
            TextAlign.center)
      )
    ];
  }

  Widget createTextField(text, style, alignment) {
    return Text(
      text,
      textAlign: TextAlign.left,
      style: style,
    );
  }
}
