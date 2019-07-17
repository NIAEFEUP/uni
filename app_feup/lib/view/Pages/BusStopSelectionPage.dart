import 'package:app_feup/controller/networking/NetworkRouter.dart';
import 'package:app_feup/model/AppState.dart';
import 'package:flutter/material.dart';
import '../Pages/SecondaryPageView.dart';
import 'package:flutter_redux/flutter_redux.dart';

class BusStopSelectionPage extends SecondaryPageView {

  final double borderRadius = 15.0;
  final DateTime now = new DateTime.now();

  BusStopSelectionPage({
    Key key
  });

  @override
  Widget getBody(BuildContext context) {
    return StoreConnector<AppState, List<dynamic>>(
      converter: (store) => store.state.content['busstops'],
      builder: (context, busStops){
        return ListView(
            children: <Widget>[
              Text("Current bus stops:"),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(context: context, delegate: busStopSearch());
                }
              )

        ]
        );
      },
    );
  }
}

class busStopSearch extends SearchDelegate<String> {

  final stopList = [
    "FEUP",
    "FCUP",
    "FADEUP",
    "FMUP",
    "Campus"
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: () {
      query = "";
    })];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        }
        );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return BusStopSelectionPage();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionsList = NetworkRouter.getStopsByName(query);

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          showResults(context);
        },
        leading: Icon(Icons.directions_bus),
        title: RichText(text: TextSpan(
          text: suggestionsList[index].substring(0, query.length),
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                  text: suggestionsList[index].substring(query.length),
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal
                  )
                )
              ]
          ),
        ),
      ),
      itemCount: suggestionsList.length,
    );
  }

}