import 'package:flutter/material.dart';

class CanteenRow extends StatelessWidget {
  final String local;
  final String meatMenu;
  final String fishMenu;
  final String vegetarianMenu;
  final String dietMenu;
  final double iconSize;

  CanteenRow(
      {Key key,
        @required this.local,
        @required this.meatMenu,
        @required this.fishMenu,
        @required this.vegetarianMenu,
        @required this.dietMenu,
        this.iconSize = 20.0,
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
                        width: 0.7, color: Theme.of(context).accentColor))),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget> [
                  Icon(Icons.restaurant, size: this.iconSize),
                  Expanded(
                      child: Text(this.meatMenu,
                        textAlign: TextAlign.center
                      )
                  ) ,
              ]
            )),
        Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: 0.7, color: Theme.of(context).accentColor))),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget> [
                  Icon(Icons.restaurant, size: this.iconSize),
                  Expanded(
                      child: Text(this.fishMenu,
                          textAlign: TextAlign.center
                      )
                  ) ,
              ]
            )),
        Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: 0.7, color: Theme.of(context).accentColor))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [
                  Icon(Icons.restaurant, size: this.iconSize),
                  Expanded(
                    child: Text(this.vegetarianMenu,
                        textAlign: TextAlign.center
                    )
                ) ,
              ]
            )),
        Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: 0.7, color: Theme.of(context).accentColor))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [
                  Icon(Icons.restaurant, size: this.iconSize),
                  Expanded(
                       child: Text(this.dietMenu,
                           textAlign: TextAlign.center
                    )
                ) ,
              ]
            )),
      ];
}
