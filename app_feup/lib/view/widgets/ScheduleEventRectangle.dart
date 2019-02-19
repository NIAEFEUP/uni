import 'package:flutter/material.dart';

class ScheduleEventRectangle extends StatelessWidget{
  final String subject;
  final String rooms;
  final double borderRadius = 12.0;
  final double leftPadding = 12.0;

  ScheduleEventRectangle({Key key,
    @required this.subject,
    @required this.rooms}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new ConstrainedBox(
      constraints: new BoxConstraints(
          minWidth: MediaQuery.of(context).size.width * 0.6,
          minHeight: 30,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
          maxHeight: 65
      ),
      child: new Container(
        margin: EdgeInsets.only(left: 24.0, top: 2.0),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(this.borderRadius)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Container(
              margin: EdgeInsets.only(top: 5.0),
              child: new Text(this.subject, style: TextStyle(color: Theme.of(context).accentColor),),
            ),
            new Container(
              margin: EdgeInsets.only(top: 13.0),
              child: new Text(this.rooms, style: TextStyle(color: Theme.of(context).accentColor),),
            )
          ],
        ),
      ),
    );
  }
}