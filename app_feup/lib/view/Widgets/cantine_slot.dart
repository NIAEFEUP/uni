import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni/view/Widgets/row_container.dart';

class CantineSlot extends StatelessWidget {
  final String type;
  final String name;

  CantineSlot({
    Key key,
    @required this.type,
    @required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return RowContainer(
        child: Container(
      padding:
        EdgeInsets.only(top: 10.0, bottom: 10.0, left: 22.0, right: 22.0),
          child: createCantineSlotRow(context),
    ));
  }

  Widget createCantineSlotRow(context) {
    return  Container(
        key: Key('cantine-slot-type-${this.type}'),
        margin: EdgeInsets.only(top: 3.0, bottom: 3.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: createCantineSlotPrimInfo(context),
        ));
  }

  Widget createCantineSlotType(context) {
    return  Column(
      key: Key('cantine-slot-type-${this.type}'),
      children: <Widget>[
        createCantineType(this.type, context)
      ],
    );
  }

  Widget createCantineType(String type, context) => createTextField(
      type,
      Theme.of(context).textTheme.headline4.apply(fontSizeDelta: -4),
      TextAlign.center);

  List<Widget> createCantineSlotPrimInfo(context){
    final nameTextField = createTextField(
        this.name,
        Theme.of(context).textTheme.headline3.apply(fontSizeDelta: 5),
        TextAlign.center);

    return [
      createCantineSlotType(context),
      Column(
          children: <Widget>[
          Row(
          children: <Widget>[
          nameTextField,
          ],
      ),
      ],
      ),
    ];
  }

  Widget createTextField(text, style, alignment) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: style,
    );
  }
}