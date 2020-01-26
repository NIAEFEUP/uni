import 'dart:async';
import 'dart:math';

import 'package:app_feup/controller/local_storage/AppBusStopDatabase.dart';
import 'package:app_feup/controller/networking/NetworkRouter.dart';
import 'package:app_feup/model/AppState.dart';
import 'package:app_feup/model/entities/BusStop.dart';
import 'package:app_feup/redux/ActionCreators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'BusesForm.dart';

class BusStopSearch extends SearchDelegate<String> {
  List<String> suggestionsList = new List();
  AppBusStopDatabase db;
  BusStop stopToAdd;

  BusStopSearch() {
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

  void updateStopCallback(BusStop stop) {
    this.stopToAdd = stop;
  }

  Widget getSuggestionList(BuildContext context) {
    if(this.suggestionsList.length == 0)
      return ListView();
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
          onTap: () {
            Navigator.pop(context);
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return busListing(context, this.suggestionsList[index]);
                }
            );
          },
          leading: Icon(Icons.directions_bus),
          title: Text(this.suggestionsList[index])
      ),
      itemCount: min(this.suggestionsList.length,9),
    );
  }

  Widget busListing(BuildContext context, String suggestion) {
    BusesForm busesForm = new BusesForm(suggestion.splitMapJoin(RegExp(r"\[[A-Z0-9_]+\]"), onMatch: (m) => '${m.group(0).substring(1, m.group(0).length-1)}', onNonMatch: (m) => ''), updateStopCallback);
    return AlertDialog(
        title: Text("Seleciona os autocarros dos quais queres informação:"),
        content: Container(
          child: busesForm,
          height: 200.0,
          width: 100.0,
        ),
        actions: [
          FlatButton(child: Text("Confirmar", style: Theme.of(context).textTheme.display1.apply(color: Theme.of(context).primaryColor),), onPressed: () async {
            await db.addBusStop(stopToAdd);
            StoreProvider.of<AppState>(context).dispatch(setUserBusStops(new Completer()));
            Navigator.pop(context);
          }),
          FlatButton(child: Text("Cancelar", style: Theme.of(context).textTheme.display1.apply(color: Theme.of(context).primaryColor),), onPressed: () => Navigator.pop(context))
        ]
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: this.getStops(),
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());
        if (snapshot.connectionState == ConnectionState.done && !snapshot.hasError) {
          if (snapshot.data.length == 0)
            return Text("No results found.");
          else
            this.suggestionsList = snapshot.data;
        } else this.suggestionsList = [];
        return getSuggestionList(context);
      },
      initialData: null,
    );
  }

  Future<List<String>> getStops() async {
    if(query != "") {
      return NetworkRouter.getStopsByName(query);
    }
    return [];
  }
}