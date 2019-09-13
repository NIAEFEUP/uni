import 'dart:math';

import 'package:app_feup/controller/local_storage/AppBusStopDatabase.dart';
import 'package:app_feup/controller/networking/NetworkRouter.dart';
import 'package:app_feup/model/AppState.dart';
import 'package:flutter/material.dart';
import '../Pages/SecondaryPageView.dart';
import 'package:flutter_redux/flutter_redux.dart';

class BusStopSelectionPage extends SecondaryPageView {

  final double borderRadius = 15.0;
  final DateTime now = new DateTime.now();

  BusStopSelectionPage({Key key});

  @override
  Widget getBody(BuildContext context) {
    return StoreConnector<AppState, List<dynamic>>(
      converter: (store) => store.state.content['busstops'],
      builder: (context, busStops) {
        return stopsListing();
      },
    );
  }
}

class stopsListing extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _stopsListingState();
}

class _stopsListingState extends State<stopsListing>{
  List<String> configuredStops = new List();
  AppBusStopDatabase db;

  _stopsListingState() {
    this.getDatabase();
  }

  Future<void> getDatabase() async {
    db = await AppBusStopDatabase();
  }

  Future<void> updateConfiguredStops() async {
    await getDatabase();
    configuredStops = await db.busStops();
    this.setState((){});
  }

  List<Widget> getConfiguredStops() {
    updateConfiguredStops();
    List<Widget> stops = new List();
    for (String stop in configuredStops) {
      stops.add(Text(stop));
    }
    return stops;
  }

  List<String> getConfiguredStopsStrings() {
    updateConfiguredStops();
    List<String> stops = new List();
    for (String stop in configuredStops) {
      stops.add(stop);
    }
    return stops;
  }

  @override
  Widget build(BuildContext context) {
    this.updateConfiguredStops();
    return ListView(
        children: <Widget>[
          Text("Current bus stops:"),
          Column(
              mainAxisSize: MainAxisSize.max,
              children: List.generate(getConfiguredStops().length, (i) {
                return Row(
                    children: <Widget>[
                      getConfiguredStops()[i],
                      IconButton(
                        icon: Icon(Icons.cancel),
                        onPressed: () {
                          db.removeBusStop(configuredStops[i]);
                          this.updateConfiguredStops();
                        },
                      )
                    ]
                );
              })
          ),
          Align(
              alignment: Alignment.center,
              child: RaisedButton(
                  child: Text("Add Stop"),
                  onPressed: () {
                    showSearch(context: context, delegate: busStopSearch());
                  }
              )
          )

        ]
    );
  }
}

class busStopSearch extends SearchDelegate<String> {
  List<String> suggestionsList = new List();
  AppBusStopDatabase db;

  busStopSearch() {
    this.getDatabase();
  }

  Future<void> getDatabase() async {
    db = await AppBusStopDatabase();
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: () {
      query = "";
    })];
  }

  @override
  Widget buildLeading(BuildContext context) { //Back arrow to go back to menu

    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        }
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    db.addBusStop(query);
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    this.getStops();
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
          onTap: () {
            db.addBusStop(suggestionsList[index].splitMapJoin(RegExp(r"\[[A-Z0-9_]+\]"), onMatch: (m) => '${m.group(0).substring(1, m.group(0).length-1)}', onNonMatch: (m) => ''));
            Navigator.pop(context);
          },
          leading: Icon(Icons.directions_bus),
          title: Text(suggestionsList[index])
      ),
      itemCount: min(suggestionsList.length-1,9),
    );
  }

  void getStops() async {
    this.suggestionsList = await NetworkRouter.getStopsByName(query);
  }
}