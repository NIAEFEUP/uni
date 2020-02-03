import 'dart:async';

import 'package:app_feup/controller/local_storage/AppBusStopDatabase.dart';
import 'package:app_feup/model/AppState.dart';
import 'package:app_feup/model/entities/BusStop.dart';
import 'package:app_feup/redux/ActionCreators.dart';
import 'package:app_feup/view/Pages/UnnamedPageView.dart';
import 'package:app_feup/view/Widgets/BusStopSearch.dart';
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

  Future deleteStop(BuildContext context, BusStop stop) async {
    StoreProvider.of<AppState>(context).dispatch(removeUserBusStop(new Completer(), stop));
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
                      "As primeiras 6 paragens (a vermelho) serão apresentadas no widget \"Paragens\" dos favoritos. As restantes aparecem quando clicas nele.",
                      textAlign: TextAlign.center
                  )
              ),
              Column(
                  children: busStops.asMap().map((index, stop) =>
                      MapEntry(index, Container(
                          padding: EdgeInsets.only(top: 8.0, bottom: 8.0, left: 90.0, right: 90.0),
                          child: RowContainer(
                              borderColor: index < 6 ? Theme.of(context).primaryColor : null,
                              child: Container(
                                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
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
                      ))
                  ).values.toList()
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