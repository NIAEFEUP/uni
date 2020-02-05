import 'dart:async';

import 'package:app_feup/model/AppState.dart';
import 'package:app_feup/model/entities/BusStop.dart';
import 'package:app_feup/redux/ActionCreators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'RowContainer.dart';

class BusStopSelectionRow extends StatefulWidget {
  BusStop stop;

  BusStopSelectionRow(this.stop);

  @override
  State<StatefulWidget> createState() => BusStopSelectionRowState(this.stop);
}

class BusStopSelectionRowState extends State<BusStopSelectionRow>{
  BusStop stop;

  BusStopSelectionRowState(this.stop);

  Future deleteStop(BuildContext context) async {
    StoreProvider.of<AppState>(context).dispatch(removeUserBusStop(new Completer(), this.stop));
  }

  Future toggleFavorite(BuildContext context) async {
    StoreProvider.of<AppState>(context).dispatch(toggleFavoriteUserBusStop(new Completer(), this.stop));
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<BusStop>>(
        converter: (store) => store.state.content['busstops'],
        builder: (context, busStops) {
          return Container(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0, left: 90.0, right: 90.0),
              child: RowContainer(
                  borderColor: Theme.of(context).primaryColor,
                  child: Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(stop.stopCode),
                            Row(
                                children: [
                                  GestureDetector(
                                      child: Icon(stop.favorited ? Icons.star : Icons.star_border, color: Theme.of(context).primaryColor),
                                      onTap: () => toggleFavorite(context)
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.cancel),
                                    color: Theme.of(context).buttonColor,
                                    onPressed: () {
                                      deleteStop(context);
                                    },
                                  )
                                ]
                            )
                          ]
                      )
                  )
              )
          );
        });
  }
}
