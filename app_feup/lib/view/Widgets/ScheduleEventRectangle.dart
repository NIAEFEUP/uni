import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScheduleEventRectangle extends StatelessWidget{
  final String subject;
  final List<String> rooms;
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
          borderRadius: BorderRadius.all(Radius.circular(this.borderRadius)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
        child: new Text(this.subject, style: Theme.of(context).textTheme.display2.apply(fontSizeDelta: 8)),
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Container(
            margin: EdgeInsets.only(top: 12.0),
            padding: EdgeInsets.fromLTRB(12.0, 0, 8, 0),
            child: new Text(this.subject, style: Theme.of(context).textTheme.headline.apply(fontWeightDelta: 2)),
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
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: getScheduleRooms(context)
        )
      );
    }
    else {
      return new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[

          new Container(
            margin: EdgeInsets.only(top: 15.0, bottom: 12.0),
            child: new Text(
              this.teacher,
              style: Theme.of(context).textTheme.display1,
            ),
          ),

          new Container(
            margin: EdgeInsets.only(top: 12.0, bottom: 12.0),
            child:  new Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: getScheduleRooms(context)
            )
          )
        ],
      );
    }
    
  }


  List<Widget> getScheduleRooms(context){
    List<Widget> rooms = new List();
    for(String room in this.rooms){
      rooms.add(
          new Text(
              room,
              style: Theme.of(context).textTheme.display1,
          ),
      );
    }
    return rooms;
  }
}