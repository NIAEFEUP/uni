import 'package:app_feup/view/Theme.dart';
import 'package:flutter/material.dart';

class ScheduleTimeInterval extends StatelessWidget{
  final String begin;
  final String end;
  ScheduleTimeInterval({
    Key key,
    @required this.begin,
    @required this.end
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return  new Column(
      children: <Widget>[
        new Container(
          child: Text(this.begin,style: Theme.of(context).textTheme.display1.apply(fontSizeDelta: -3)),
          margin: EdgeInsets.only(top: 8.0),
        ),new Container(
          child: Text(this.end,style: Theme.of(context).textTheme.display1.apply(fontSizeDelta: -3)),
          margin: EdgeInsets.only(top: 8.0),
        ),
      ],
    );
  }
}