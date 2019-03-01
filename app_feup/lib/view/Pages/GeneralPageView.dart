import 'package:flutter/material.dart';
import '../widgets/NavigationDrawer.dart';
import 'package:app_feup/model/AppState.dart';
import 'package:flutter_redux/flutter_redux.dart';

abstract class GeneralPageView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(StoreProvider.of<AppState>(context).state.content["selected_page"], textAlign: TextAlign.start),
        actions: <Widget>[
          FlatButton(
            //TODO:
            //onPressed: () => {Navigator.pushReplacement(context,new MaterialPageRoute(builder: (__) => new ProfilePage()))},
            child: Container(
                width: 45.0,
                height: 45.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    //TODO: Change to profile pic when ready
                    image: NetworkImage(
                      "https://dei.fe.up.pt/gig/wp-content/uploads/sites/4/2017/02/AAS_Jorn-1-243x300.jpg")
                  )
                )
              ),
          ),
        ],),
      drawer: new NavigationDrawer(),
      body: getBody(context),
    );
  }

  Widget getBody(BuildContext context){return new Container();}
}
