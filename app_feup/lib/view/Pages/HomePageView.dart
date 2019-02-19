import 'package:app_feup/controller/parsers/parser-schedule.dart';
import 'package:app_feup/view/widgets/GenericCard.dart';
import 'package:app_feup/view/widgets/ScheduleCard.dart';
import 'package:flutter/material.dart';

class HomePageView extends StatelessWidget {
  HomePageView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("App FEUP")),
      body: createScrollableCardView(context),
      floatingActionButton: createActionButton(context),
    );
  }

  Widget createActionButton(BuildContext context){
    return new FloatingActionButton(
      onPressed: () => {}, //Add FAB functionality here
      tooltip: 'Increment',
      child: new Icon(Icons.add),
    );
  }

  Widget createScrollableCardView(BuildContext context){
    return new ListView(

        shrinkWrap: false,
        children: <Widget>[
          new Container(
            padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
            child: new Text( 'Favorites:',
              style: Theme.of(context).textTheme.title,
            ),
          )
          ,
          new GenericCard(
            title: "Horário",
            child: new ScheduleCard(
                firstLecture: new Lecture("SOPE", "TE", 1, "14:00", 4, "B303", "JAS"),
                secondLecture: new Lecture("BDAD", "TP", 1, "17:00", 2, "B204", "PMMS")),
          )
          //Cards go here


        ],
      );
  }
}