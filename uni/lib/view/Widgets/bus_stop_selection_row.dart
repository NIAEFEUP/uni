import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/bus_stop.dart';
import 'package:uni/redux/action_creators.dart';
import 'package:uni/view/Widgets/row_container.dart';

class BusStopSelectionRow extends StatefulWidget {
  final String stopCode;
  final BusStopData stopData;

  const BusStopSelectionRow(this.stopCode, this.stopData, {super.key});

  @override
  State<StatefulWidget> createState() => BusStopSelectionRowState();
}

class BusStopSelectionRowState extends State<BusStopSelectionRow> {
  BusStopSelectionRowState();

  Future deleteStop(BuildContext context) async {
    StoreProvider.of<AppState>(context)
        .dispatch(removeUserBusStop(Completer(), widget.stopCode));
  }

  Future toggleFavorite(BuildContext context) async {
    StoreProvider.of<AppState>(context).dispatch(toggleFavoriteUserBusStop(
        Completer(), widget.stopCode, widget.stopData));
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
                  color: Theme.of(context).primaryColor,
                  child: Container(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(widget.stopCode),
                            Row(children: [
                              GestureDetector(
                                  child: Icon(
                                      widget.stopData.favorited
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                  onTap: () => toggleFavorite(context)),
                              IconButton(
                                icon: const Icon(Icons.cancel),
                                onPressed: () {
                                  deleteStop(context);
                                },
                              )
                            ])
                          ]))));
        });
  }
}
