import 'dart:async';

import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/bus_stop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/redux/action_creators.dart';
import 'package:uni/view/Widgets/row_container.dart';

class BusStopSelectionRow extends StatefulWidget {
  final String stopCode;
  final BusStopData stopData;

  BusStopSelectionRow(this.stopCode, this.stopData);

  @override
  State<StatefulWidget> createState() =>
      BusStopSelectionRowState(this.stopCode, this.stopData);
}

class BusStopSelectionRowState extends State<BusStopSelectionRow> {
  final String stopCode;
  final BusStopData stopData;

  BusStopSelectionRowState(this.stopCode, this.stopData);

  Future deleteStop(BuildContext context) async {
    StoreProvider.of<AppState>(context)
        .dispatch(removeUserBusStop(Completer(), this.stopCode));
  }

  Future toggleFavorite(BuildContext context) async {
    StoreProvider.of<AppState>(context).dispatch(
        toggleFavoriteUserBusStop(Completer(), this.stopCode, this.stopData));
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Map<String, BusStopData>>(
        converter: (store) => store.state.content['configuredBusStops'],
        builder: (context, busStops) {
          final width = MediaQuery.of(context).size.width;
          return Container(
              padding: EdgeInsets.only(
                  top: 8.0,
                  bottom: 8.0,
                  left: width * 0.20,
                  right: width * 0.20),
              child: RowContainer(
                  borderColor: Theme.of(context).accentColor,
                  child: Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(stopCode),
                            Row(children: [
                              GestureDetector(
                                  child: Icon(
                                      stopData.favorited
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: Theme.of(context).accentColor),
                                  onTap: () => toggleFavorite(context)),
                              IconButton(
                                icon: Icon(Icons.cancel),
                                color: Theme.of(context).buttonColor,
                                onPressed: () {
                                  deleteStop(context);
                                },
                              )
                            ])
                          ]))));
        });
  }
}
