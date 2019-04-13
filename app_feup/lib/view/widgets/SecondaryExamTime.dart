import 'package:app_feup/view/Theme.dart';
import 'package:flutter/material.dart';

class SecondaryExamTime extends StatelessWidget{
  final String begin;
  final String day;
  final String month;


  SecondaryExamTime({
    Key key,
    @required this.begin,
    @required this.day,
    @required this.month
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Container(
            child: Text(this.day + "/" + this.month, style: Theme.of(context).textTheme.subtitle.apply(fontSizeDelta: 1, fontWeightDelta: 1),),
          ),
          new Container(
            child: Text(this.begin,style: Theme.of(context).textTheme.display1.apply(color: greyTextColor, fontSizeDelta: -5)),
            margin: EdgeInsets.only(top: 8.0),
          ),
        ],
      ),
    );
  }
}