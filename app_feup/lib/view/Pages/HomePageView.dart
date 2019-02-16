import 'package:flutter/material.dart';

import '../widgets/NavigationDrawer.dart';

class HomePageView extends StatelessWidget {
  HomePageView({Key key}) : super(key: key);

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
      tooltip: 'Increment',
      child: new Icon(Icons.add),
    );
  }

  Widget createScrollableCardView(BuildContext context){
    return new ListView(

        shrinkWrap: false,
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          new Text(
            'Favorites:',
            style: Theme.of(context).textTheme.title,
          ),

          //Cards go here

        ],
      );
  }
}