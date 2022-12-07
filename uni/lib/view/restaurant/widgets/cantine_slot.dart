import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni/view/common_widgets/row_container.dart';

class CantineSlot extends StatelessWidget {
  final String type;
  final String name;

  CantineSlot({
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
    return
      Text('C',
        style: TextStyle(
          color: Colors.red,
          fontSize: 20,

        ),
      );
      //createCantineType(type, context);
  }

  Widget createCantineType(String type, context) => createTextField(
      type,
      Theme.of(context).textTheme.bodyMedium,
      TextAlign.left);

  List<Widget> createCantineSlotPrimInfo(context) {
    return [
      Container(
          margin: EdgeInsets.fromLTRB(0, 0, 8.0, 0),
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
    return Container(
        child: Text(
      text,
      textAlign: TextAlign.left,
      style: style,
    ));
  }
}
