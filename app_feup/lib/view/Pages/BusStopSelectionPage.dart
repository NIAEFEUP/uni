import 'dart:io';

import 'package:app_feup/controller/local_storage/AppBusStopDatabase.dart';
import 'package:app_feup/controller/networking/NetworkRouter.dart';
import 'package:app_feup/model/AppState.dart';
import 'package:flutter/material.dart';
import '../Pages/SecondaryPageView.dart';
import 'package:flutter_redux/flutter_redux.dart';

class BusStopSelectionPage extends SecondaryPageView {

  final double borderRadius = 15.0;
  final DateTime now = new DateTime.now();
  List<String> configuredStops = new List();
  AppBusStopDatabase db;

  BusStopSelectionPage({Key key}) {
    this.getDatabase();
  }

  Future<void> getDatabase() async {
    db = await AppBusStopDatabase();
  }

  Future<void> updateConfiguredStops() async {
    await getDatabase();
    configuredStops = await db.busStops();
  }

  List<Widget> getConfiguredStops() {
    updateConfiguredStops();
    List<Widget> stops = new List();
    for (String stop in configuredStops) {
      stops.add(Text(stop));
    }
    return stops;
  }

  @override
  Widget getBody(BuildContext context) {
    return StoreConnector<AppState, List<dynamic>>(
      converter: (store) => store.state.content['busstops'],
      builder: (context, busStops) {
        return ListView(
            children: <Widget>[
              Text("Current bus stops:"),
              IconButton(
                icon: Icon(Icons.ac_unit),
                onPressed: () {
                  db.addBusStop("STCP_FEUP1");
                }
              ),
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
                                updateConfiguredStops();
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
      },
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
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //this.suggestionsList.clear();
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
      itemCount: suggestionsList.length-1,
    );
  }

  void getStops() async {
    this.suggestionsList = await NetworkRouter.getStopsByName(query);
  }
}