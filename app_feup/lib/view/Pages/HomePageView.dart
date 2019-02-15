import 'package:app_feup/view/widgets/GenericCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:app_feup/model/AppState.dart';
import 'package:app_feup/redux/actionCreators.dart';

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