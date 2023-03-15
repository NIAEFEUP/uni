import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/entities/bus_stop.dart';
import 'package:uni/model/providers/bus_stop_provider.dart';
import 'package:uni/view/common_widgets/row_container.dart';

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
    Provider.of<BusStopProvider>(context, listen: false)
        .removeUserBusStop(Completer(), widget.stopCode);
  }

  Future toggleFavorite(BuildContext context) async {
    Provider.of<BusStopProvider>(context, listen: false)
        .toggleFavoriteUserBusStop(
            Completer(), widget.stopCode, widget.stopData);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
        padding: EdgeInsets.only(
            top: 8.0, bottom: 8.0, left: width * 0.20, right: width * 0.20),
        child: RowContainer(
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
                            ),
                            onTap: () => toggleFavorite(context)),
                        IconButton(
                          icon: const Icon(Icons.cancel),
                          onPressed: () {
                            deleteStop(context);
                          },
                        )
                      ])
                    ]))));
  }
}
