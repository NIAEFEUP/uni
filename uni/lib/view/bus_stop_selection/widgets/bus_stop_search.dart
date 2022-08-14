import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/controller/fetchers/departures_fetcher.dart';
import 'package:uni/controller/local_storage/app_bus_stop_database.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/bus_stop.dart';
import 'package:uni/redux/action_creators.dart';
import 'package:uni/view/bus_stop_selection/widgets/form.dart';

/// Manages the section of the app displayed when the
/// user searches for a bus stop
class BusStopSearch extends SearchDelegate<String> {
  List<String> suggestionsList = [];
  late final AppBusStopDatabase db;
  String? stopCode;
  BusStopData? stopData;

  BusStopSearch() {
    getDatabase();
  }

  Future<void> getDatabase() async {
    db = AppBusStopDatabase();
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //Back arrow to go back to menu

    return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return getSuggestionList(context);
  }

  void updateStopCallback(String stopCode, BusStopData stopData) {
    this.stopCode = stopCode;
    this.stopData = stopData;
  }

  /// Returns a widget for the list of search suggestions displayed to  the user
  Widget getSuggestionList(BuildContext context) {
    if (suggestionsList.isEmpty) return ListView();
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
          onTap: () {
            Navigator.pop(context);
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return busListing(context, suggestionsList[index]);
                });
          },
          leading: const Icon(Icons.directions_bus),
          title: Text(suggestionsList[index])),
      itemCount: min(suggestionsList.length, 9),
    );
  }

  Widget busListing(BuildContext context, String suggestion) {
    final BusesForm busesForm = BusesForm(
        suggestion.splitMapJoin(RegExp(r'\[[A-Z0-9_]+\]'),
            onMatch: (m) => m.group(0)!.substring(1, m.group(0)!.length - 1),
            onNonMatch: (m) => ''),
        updateStopCallback);
    return AlertDialog(
        title:
            const Text('Seleciona os autocarros dos quais queres informação:'),
        content: SizedBox(
          height: 200.0,
          width: 100.0,
          child: busesForm,
        ),
        actions: [
          TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.pop(context)),
          ElevatedButton(
              child: const Text('Confirmar'),
              onPressed: () async {
                if (stopData!.configuredBuses.isNotEmpty) {
                  StoreProvider.of<AppState>(context).dispatch(
                      addUserBusStop(Completer(), stopCode!, stopData!));
                  Navigator.pop(context);
                }
              })
        ]);
  }

  /// Returns a widget for the suggestions list displayed to the user.
  ///
  /// If the suggestions list is empty a text warning about no results found
  /// is displayed.
  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: getStops(),
      builder: (BuildContext context, AsyncSnapshot<List<String>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.connectionState == ConnectionState.done &&
            !snapshot.hasError) {
          if (snapshot.data!.isEmpty) {
            return Container(
                margin: const EdgeInsets.all(8.0),
                height: 24.0,
                child: const Center(
                  child: Text('Sem resultados.'),
                ));
          } else {
            suggestionsList = snapshot.data!;
          }
        } else {
          suggestionsList = [];
        }
        return getSuggestionList(context);
      },
      initialData: null,
    );
  }

  Future<List<String>> getStops() async {
    if (query != '') {
      return DeparturesFetcher.getStopsByName(query);
    }
    return [];
  }
}
