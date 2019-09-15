import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScheduleEventRectangle extends StatelessWidget{
  final String subject;
  final String type;
  final double borderRadius = 12.0;
  final double sideSizing = 12.0;

  ScheduleEventRectangle({Key key,
    @required this.subject,
    this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: this.createTopRectangle(context),
    );
  }

  Widget createTopRectangle(context){
    if (type == null){
      return Container(
        child: new Text(this.subject, style: Theme.of(context).textTheme.display2.apply(fontSizeDelta: 5)),
      );
    } else {
      return new Container(
        padding: EdgeInsets.fromLTRB(12.0, 0, 8, 0),
        child: new Text(this.subject, style: Theme.of(context).textTheme.headline.apply(fontWeightDelta: 2)),
      );
    }
  }
}