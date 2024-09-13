import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/entities/bus_stop.dart';
import 'package:uni/model/providers/lazy/bus_stop_provider.dart';
import 'package:uni/view/common_widgets/row_container.dart';

class BusStopSelectionRow extends StatefulWidget {
  const BusStopSelectionRow(this.stopCode, this.stopData, {super.key});
  final String stopCode;
  final BusStopData stopData;

  @override
  State<StatefulWidget> createState() => BusStopSelectionRowState();
}

class BusStopSelectionRowState extends State<BusStopSelectionRow> {
  BusStopSelectionRowState();

  Future<void> deleteStop(BuildContext context) async {
    unawaited(
      Provider.of<BusStopProvider>(context, listen: false)
          .removeUserBusStop(widget.stopCode),
    );
  }

  Future<void> toggleFavorite(BuildContext context) async {
    unawaited(
      Provider.of<BusStopProvider>(context, listen: false)
          .toggleFavoriteUserBusStop(widget.stopCode, widget.stopData),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.only(
        top: 8,
        bottom: 8,
        left: width * 0.20,
        right: width * 0.20,
      ),
      child: RowContainer(
        child: Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(widget.stopCode),
              Row(
                children: [
                  GestureDetector(
                    child: Icon(
                      widget.stopData.favorited
                          ? Icons.star
                          : Icons.star_border,
                    ),
                    onTap: () => toggleFavorite(context),
                  ),
                  IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () {
                      deleteStop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
