import 'package:app_feup/controller/homePage.dart';
import 'package:flutter/material.dart';
import '../widgets/GenericCard.dart';
import '../widgets/ExamMapCard.dart';
import '../widgets/NavigationDrawer.dart';

class HomePageView extends StatelessWidget {
  HomePageView({Key key, @required store}) : super(key: key) {
        loadUserInfoToState(store);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("App FEUP")),
      drawer: new NavigationDrawer(),
      body: createScrollableCardView(context),
      floatingActionButton: createActionButton(context),
    );
  }

  Widget createActionButton(BuildContext context){
    return new FloatingActionButton(
      onPressed: () => {}, //Add FAB functionality here
      tooltip: 'Add widget',
      child: new Icon(Icons.add),
    );
  }

  Widget createScrollableCardView(BuildContext context){
    return new ListView(

        shrinkWrap: false,
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          new ExamMapCard()
          //Cards go here

          ],
      );
  }
}