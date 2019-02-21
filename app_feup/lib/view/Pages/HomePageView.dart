import 'package:app_feup/controller/parsers/parser-schedule.dart';
import 'package:app_feup/view/widgets/GenericCard.dart';
import 'package:app_feup/view/widgets/ScheduleCard.dart';
import 'package:app_feup/controller/homePage.dart';
import 'package:flutter/material.dart';
import '../widgets/GenericCard.dart';
import '../widgets/ExamCard.dart';
import '../widgets/NavigationDrawer.dart';

class HomePageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("App FEUP")),
      drawer: new NavigationDrawer(),
      body: createScrollableCardView(context),
      floatingActionButton: createActionButton(context),
    );
  }

  Widget createActionButton(BuildContext context) {
    return new FloatingActionButton(
      onPressed: () => {}, //Add FAB functionality here
      tooltip: 'Add widget',
      child: new Icon(Icons.add),
    );
  }

  Widget createScrollableCardView(BuildContext context) {
    return new ListView(
      shrinkWrap: false,
      children: <Widget>[
        new Container(
          padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
          child: new Text(
            'Favorites:',
            style: Theme.of(context).textTheme.title,
          ),
        ),
        new GenericCard(
            title: "Exames",
            child: new ExamCard()
        ),
        new GenericCard(
          title: "Horário",
          child: new ScheduleCard(),
        ),
        //Cards go here
      ],
    );
  }
}
