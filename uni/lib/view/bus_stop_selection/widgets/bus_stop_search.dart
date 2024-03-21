import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/controller/fetchers/departures_fetcher.dart';
import 'package:uni/controller/local_storage/database/app_bus_stop_database.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/bus_stop.dart';
import 'package:uni/model/providers/lazy/bus_stop_provider.dart';
import 'package:uni/view/bus_stop_selection/widgets/form.dart';

/// Manages the section of the app displayed when the
/// user searches for a bus stop
class BusStopSearch extends SearchDelegate<String> {
  BusStopSearch() {
    getDatabase();
  }

  List<String> suggestionsList = [];
  late final AppBusStopDatabase db;
  String? stopCode;
  BusStopData? stopData;

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
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //Back arrow to go back to menu

    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
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
    if (suggestionsList.isEmpty) {
      return ListView();
    }
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          Navigator.pop(context);
          showDialog<void>(
            context: context,
            builder: (context) {
              return busListing(context, suggestionsList[index]);
            },
          );
        },
        leading: const Icon(Icons.directions_bus),
        title: Text(suggestionsList[index]),
      ),
      itemCount: min(suggestionsList.length, 9),
    );
  }

  Widget busListing(BuildContext context, String suggestion) {
    final busesForm = BusesForm(
      suggestion.splitMapJoin(
        RegExp(r'\[[A-Z0-9_]+\]'),
        onMatch: (m) => m.group(0)!.substring(1, m.group(0)!.length - 1),
        onNonMatch: (m) => '',
      ),
      updateStopCallback,
    );
    return AlertDialog(
      title: Text(
        S.of(context).bus_information,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      content: SizedBox(
        height: 200,
        width: 100,
        child: busesForm,
      ),
      actions: [
        TextButton(
          child: Text(
            S.of(context).cancel,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          child: Text(S.of(context).confirm),
          onPressed: () async {
            if (stopData!.configuredBuses.isNotEmpty) {
              unawaited(
                Provider.of<BusStopProvider>(context, listen: false)
                    .addUserBusStop(stopCode!, stopData!),
              );
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }

  /// Returns a widget for the suggestions list displayed to the user.
  ///
  /// If the suggestions list is empty a text warning about no results found
  /// is displayed.
  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: getStops(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.connectionState == ConnectionState.done &&
            !snapshot.hasError) {
          if (snapshot.data!.isEmpty) {
            return Container(
              margin: const EdgeInsets.all(8),
              height: 24,
              child: Center(
                child: Text(S.of(context).no_results),
              ),
            );
          } else {
            suggestionsList = snapshot.data!;
          }
        } else {
          suggestionsList = [];
        }
        return getSuggestionList(context);
      },
    );
  }

  Future<List<String>> getStops() async {
    if (query != '') {
      return DeparturesFetcher.getStopsByName(query);
    }
    return [];
  }
}
