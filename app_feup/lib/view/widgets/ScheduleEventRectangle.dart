import 'package:flutter/material.dart';

class ScheduleEventRectangle extends StatelessWidget{
  final String subject;
  final String rooms;
  final String teacher;
  final String type;
  final double borderRadius = 12.0;
  final double sideSizing = 12.0;

  ScheduleEventRectangle({Key key,
    @required this.subject,
    @required this.rooms,
    this.teacher,
    this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Expanded(
      child: new Container(
        margin: EdgeInsets.only(left: 24.0, right: this.sideSizing),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(this.borderRadius)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            this.createTopRectangle(context),
            this.createBottomRectangle(context)
          ],
        ),
      ),
    );
  }

  Widget createTopRectangle(context){
    if (type == null){
      return Container(
        margin: EdgeInsets.only(top: 12.0),
        child: new Text(this.subject, style: Theme.of(context).textTheme.display1.apply(fontWeightDelta: 2)),
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Container(
            margin: EdgeInsets.only(top: 12.0),
            padding: EdgeInsets.fromLTRB(12.0, 0, 8, 0),
            child: new Text(this.subject, style: Theme.of(context).textTheme.display1.apply(fontWeightDelta: 2)),
          ),
          new Container(
              margin: EdgeInsets.only(top: 12.0),
              child: new Text('($type)', style: TextStyle(color: Theme.of(context).accentColor, fontSize: 14),)
          ),
        ],
      );
    }
  }
  
  Widget createBottomRectangle(context){
    if(this.teacher == null){
      return new Container(
        margin: EdgeInsets.only(top: 12.0, bottom: 12.0),
        child: new Text(this.rooms.isEmpty ? "Salas em breve": this.rooms,style: Theme.of(context).textTheme.display1
          ,),
      );
    }
    else {
      return new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[

          new Container(
            margin: EdgeInsets.only(top: 12.0, bottom: 12.0),
            child: new Text(
              this.teacher,
              style: Theme.of(context).textTheme.display1,
            ),
          ),

          new Container(
            margin: EdgeInsets.only(top: 12.0, bottom: 12.0),
            child: new Text(
              this.rooms,
              style: Theme.of(context).textTheme.display1,
            ),
          )
        ],
      );
    }
    
  }
}