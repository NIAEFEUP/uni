import 'dart:async';

import 'package:app_feup/controller/local_storage/AppBusStopDatabase.dart';
import 'package:app_feup/model/AppState.dart';
import 'package:app_feup/model/entities/BusStop.dart';
import 'package:app_feup/redux/ActionCreators.dart';
import 'package:app_feup/view/Pages/UnnamedPageView.dart';
import 'package:app_feup/view/Widgets/BusStopSearch.dart';
import 'package:app_feup/view/Widgets/BusStopSelectionRow.dart';
import 'package:app_feup/view/Widgets/PageTitle.dart';
import 'package:app_feup/view/Widgets/RowContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../Theme.dart' show darkGreyColor;


class BusStopSelectionPage extends UnnamedPageView {

  final double borderRadius = 15.0;
  final DateTime now = new DateTime.now();

  final AppBusStopDatabase db = AppBusStopDatabase();
  final List<BusStop> configuredStops = new List();
  final List<String> suggestionsList = new List();

  List<Widget> getStopsTextList() {
    List<Widget> stops = new List();
    for (BusStop stop in configuredStops) {
      stops.add(Text(stop.stopCode));
    }
    return stops;
  }

  @override
  Widget getBody(BuildContext context) {
    return StoreConnector<AppState, List<BusStop>>(
      converter: (store) => store.state.content['busstops'],
      builder: (context, busStops) {
        return ListView(
            padding: EdgeInsets.only(bottom: 20),
            children: <Widget>[
              Container(
                  child: PageTitle(name: 'Paragens Configuradas')
              ),
              Container(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                      "As paragens favoritas serão apresentadas no widget \"Paragens\" dos favoritos. As restantes serão apresentadas apenas na página.",
                      textAlign: TextAlign.center
                  )
              ),
              Column(
                  children: busStops.map((stop) => BusStopSelectionRow(stop)).toList()
              ),
              Container(
                padding: EdgeInsets.only(left: 90.0, right: 90.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RaisedButton(
                        onPressed: () => showSearch(context: context, delegate: BusStopSearch()),
                        color: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.all(0.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(12.0),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(15.0),
                          child: Text("Adicionar", style: Theme.of(context).textTheme.title.apply(color: Colors.white)),
                        ),
                      ),
                      RaisedButton(
                        onPressed: () => Navigator.pop(context),
                        color: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.all(0.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(12.0),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(15.0),
                          child: Text("Concluído", style: Theme.of(context).textTheme.title.apply(color: Colors.white)),
                        ),
                      ),
                    ]
                )
              )
            ]
        );
      },
    );
  }
}