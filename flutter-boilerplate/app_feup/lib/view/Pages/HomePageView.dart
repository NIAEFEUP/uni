import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:app_feup/model/AppState.dart';
import 'package:app_feup/redux/actionCreators.dart';

class HomePageView extends StatelessWidget {
  HomePageView({Key key,
    @required this.title}) : super(key: key);

  final String title;

  /*********** MAIN BUILD METHOD ***********/
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(title),
      ),
      body: createCounterDisplay(context),
      floatingActionButton: createActionButton(context),
    );
  }



  dynamic createActionButton(BuildContext context){
    return new StoreConnector<AppState, Function>(
        converter: (store) => () => store.dispatch(login("user", "password")),
        builder: (context, callback) {
          return new FloatingActionButton(
            onPressed: ()=>callback(),
            tooltip: 'Testing app state',
            child: new Icon(Icons.add),
          );}
          );
  }

  Widget createCounterDisplay(BuildContext context){
    return new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(
            'This is a dummy text',
            style: Theme.of(context).textTheme.body1,
          ),
        ],
      ),
    );
  }
}
