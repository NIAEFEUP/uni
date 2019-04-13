import 'package:app_feup/view/Theme.dart';
import 'package:flutter/material.dart';

class ExamTime extends StatelessWidget{
  final String begin;
  final String day;
  final String month;


  ExamTime({
    Key key,
    @required this.begin,
    @required this.day,
    @required this.month
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return  new Column(
      children: <Widget>[
        new Container(
          child: Text(this.day, style: Theme.of(context).textTheme.subtitle.apply(fontSizeDelta: 15, fontWeightDelta: 1),),
        ),
        new Container(
          child: Text(this.month, style: Theme.of(context).textTheme.display1.apply(fontWeightDelta: 1, color: greyTextColor),),
        ),
        new Container(
          child: Text(this.begin,style: Theme.of(context).textTheme.display1.apply(color: greyTextColor, fontSizeDelta: -5)),
          margin: EdgeInsets.only(top: 8.0),
        )
      ],
    );
  }
}