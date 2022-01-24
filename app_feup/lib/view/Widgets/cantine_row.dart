import 'package:flutter/material.dart';

class CantineRow extends StatelessWidget {
  final String local;
  final String meatMenu;
  final String fishMenu;
  final String vegetarianMenu;

  CantineRow(
      {Key key,
        @required this.local,
        @required this.meatMenu,
        @required this.fishMenu,
        @required this.vegetarianMenu,
        })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
        child:  Container(
          padding: EdgeInsets.only(left: 12.0, bottom: 8.0, right: 12),
          margin: EdgeInsets.only(top: 8.0),
          child:  Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Column(children: getMenuRows(context),))
            ],
          ),
        ));
  }

  List<Widget> getMenuRows(BuildContext context) => [
        Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: 0.1, color: Theme.of(context).accentColor))),
            child: Text(this.meatMenu)),
        Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: 0.1, color: Theme.of(context).accentColor))),
            child: Text(this.fishMenu)),
        Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: 0.1, color: Theme.of(context).accentColor))),
            child: Text(this.vegetarianMenu))
      ];

}
