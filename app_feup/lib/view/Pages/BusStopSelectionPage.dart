import 'dart:async';

import 'package:app_feup/controller/local_storage/AppBusStopDatabase.dart';
import 'package:app_feup/model/AppState.dart';
import 'package:app_feup/model/entities/BusStop.dart';
import 'package:app_feup/redux/ActionCreators.dart';
import 'package:app_feup/view/Pages/UnnamedPageView.dart';
import 'package:app_feup/view/Widgets/BusStopSearch.dart';
import 'package:app_feup/view/Widgets/PageTitle.dart';
import 'package:app_feup/view/Widgets/RowContainer.dart';
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

  Future deleteStop(BuildContext context, BusStop stop) async {
    StoreProvider.of<AppState>(context).dispatch(removeUserBusStop(new Completer(), stop));
  }

  @override
  Widget getBody(BuildContext context) {
    return StoreConnector<AppState, List<BusStop>>(
      converter: (store) => store.state.content['busstops'],
      builder: (context, busStops) {
        return ListView(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.only(bottom: 12.0, right: 22.0),
                  child: PageTitle(name: 'Paragens Configuradas')
              ),
              Column(
                  children: busStops.map((stop) =>
                      Container(
                          padding: EdgeInsets.only(top: 8.0, bottom: 8.0, left: 40.0, right: 40.0),
                          child: RowContainer(
                              child: Container(
                                  padding: EdgeInsets.only(left: 60.0, right: 60.0),
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(stop.stopCode),
                                        IconButton(
                                          icon: Icon(Icons.cancel),
                                          color: darkGreyColor,
                                          onPressed: () {
                                            deleteStop(context, stop);
                                          },
                                        )
                                      ]
                                  )
                              )
                          )
                      )
                  ).toList()
              ),
              Align(
                  alignment: Alignment.center,
                  child: RaisedButton(
                      child: Text("Adicionar"),
                      onPressed: () {
                        showSearch(context: context, delegate: BusStopSearch());
                      }
                  )
              )

            ]
        );
      },
    );
  }
}