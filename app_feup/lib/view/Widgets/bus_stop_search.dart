import 'dart:async';
import 'dart:math';

import 'package:uni/controller/local_storage/app_bus_stop_database.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/bus_stop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/redux/action_creators.dart';
import 'package:uni/view/Widgets/buses_form.dart';

class BusStopSearch extends SearchDelegate<String> {
  List<String> suggestionsList =  [];
  AppBusStopDatabase db;
  String stopCode;
  BusStopData stopData;

  BusStopSearch() {
    this.getDatabase();
  }

  Future<void> getDatabase() async {
    db = AppBusStopDatabase();
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //Back arrow to go back to menu

    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  void updateStopCallback(String stopCode, BusStopData stopData) {
    this.stopCode = stopCode;
    this.stopData = stopData;
  }

  Widget getSuggestionList(BuildContext context) {
    if (this.suggestionsList.isEmpty) return ListView();
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
          onTap: () {
            Navigator.pop(context);
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return busListing(context, this.suggestionsList[index]);
                });
          },
          leading: Icon(Icons.directions_bus),
          title: Text(this.suggestionsList[index])),
      itemCount: min(this.suggestionsList.length, 9),
    );
  }

  Widget busListing(BuildContext context, String suggestion) {
    final BusesForm busesForm =  BusesForm(
        suggestion.splitMapJoin(RegExp(r'\[[A-Z0-9_]+\]'),
            onMatch: (m) => '${m.group(0).substring(1, m.group(0).length - 1)}',
            onNonMatch: (m) => ''),
        updateStopCallback);
    return AlertDialog(
        title: Text('Seleciona os autocarros dos quais queres informação:'),
        content: Container(
          child: busesForm,
          height: 200.0,
          width: 100.0,
        ),
        actions: [
          TextButton(
              child: Text('Cancelar',
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      .apply(color: Theme.of(context).primaryColor)),
              onPressed: () => Navigator.pop(context)),
          TextButton(
              child: Text('Confirmar',
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      .apply(color: Theme.of(context).accentColor)),
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius:  BorderRadius.circular(10.0),
                    side: BorderSide(color: Theme.of(context).primaryColor)),
              ),
              onPressed: () async {
                if (stopData.configuredBuses.isNotEmpty) {
                  StoreProvider.of<AppState>(context).dispatch(
                      addUserBusStop( Completer(), stopCode, stopData));
                  Navigator.pop(context);
                }
              })
        ]);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: this.getStops(),
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.connectionState == ConnectionState.done &&
            !snapshot.hasError) {
          if (snapshot.data.isEmpty) {
            return Container(
                margin: EdgeInsets.all(8.0),
                height: 24.0,
                child: Center(
                  child: Text('Sem resultados.'),
                ));
          } else {
            this.suggestionsList = snapshot.data;
          }
        } else {
          this.suggestionsList = [];
        }
        return getSuggestionList(context);
      },
      initialData: null,
    );
  }

  Future<List<String>> getStops() async {
    if (query != '') {
      return NetworkRouter.getStopsByName(query);
    }
    return [];
  }
}
