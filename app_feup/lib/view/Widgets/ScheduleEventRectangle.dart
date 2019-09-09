import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScheduleEventRectangle extends StatelessWidget{
  final String subject;
  final double borderRadius = 12.0;
  final double sideSizing = 12.0;

  ScheduleEventRectangle({Key key,
    @required this.subject}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: this.createTopRectangle(context),
    );
  }

  Widget createTopRectangle(context){
    return Container(
      child: new Text(this.subject, style: Theme.of(context).textTheme.display2.apply(fontSizeDelta: 5)),
    );
  }
}