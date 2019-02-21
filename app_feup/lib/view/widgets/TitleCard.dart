import 'package:flutter/material.dart';

class TitleCard extends StatelessWidget{

  final String day;
  final String weekDay;
  final String month;
  final double borderRadius = 15.0;
  TitleCard({
    Key key,
    @required this.day,
    @required this.weekDay,
    @required this.month,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Card(
      margin: EdgeInsets.fromLTRB(12, 12, 12, 0),
      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(this.borderRadius)),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            border: Border.all(width: 0.5, color: Color.fromARGB(64, 0x46, 0x46, 0x46)),
            borderRadius: BorderRadius.all(Radius.circular(this.borderRadius))),
        alignment: Alignment.center,
        child: new Text(
            "Meias",
          style: Theme.of(context).textTheme.title.apply(fontSizeDelta: 3, fontWeightDelta: -1),
        ),
      ),
    );
  }
}