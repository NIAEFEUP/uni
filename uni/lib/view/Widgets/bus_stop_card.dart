import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/bus_stop.dart';
import 'package:uni/model/entities/trip.dart';
import 'package:uni/utils/constants.dart' as constants;
import 'package:uni/view/Pages/bus_stop_selection_page.dart';
import 'package:uni/view/Widgets/bus_stop_row.dart';
import 'package:uni/view/Widgets/last_update_timestamp.dart';

import 'generic_card.dart';

/// Manages the bus stops card displayed on the user's personal area
class BusStopCard extends GenericCard {
  const BusStopCard.fromEditingInformation(
      Key key, bool editingMode, Function()? onDelete)
      : super.fromEditingInformation(key, editingMode, onDelete);

  @override
  String getTitle() => 'Autocarros';

  @override
  onClick(BuildContext context) =>
      Navigator.pushNamed(context, '/${constants.navStops}');

  @override
  Widget buildCardContent(BuildContext context) {
    return StoreConnector<
            AppState,
            Tuple3<Map<String, List<Trip>>, Map<String, BusStopData>,
                RequestStatus>?>(
        converter: (store) => Tuple3(
            store.state.content['currentBusTrips'],
            store.state.content['configuredBusStops'],
            store.state.content['busStopStatus']),
        builder: (context, trips) => getCardContent(
            context, trips?.item1 ?? {}, trips?.item2 ?? {}, trips?.item3));
  }

  /// Returns a widget with the bus stop card final content
  Widget getCardContent(BuildContext context, Map<String, List<Trip>> trips,
      Map<String, BusStopData> stopConfig, busStopStatus) {
    switch (busStopStatus) {
      case RequestStatus.successful:
        if (trips.isNotEmpty) {
          return Column(children: <Widget>[
            getCardTitle(context),
            getBusStopsInfo(context, trips, stopConfig)
          ]);
        } else {
          return Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Configura os teus autocarros',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.subtitle2!.apply()),
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const BusStopSelectionPage())),
                  )
                ]),
          );
        }
      case RequestStatus.busy:
        return Column(
          children: <Widget>[
            getCardTitle(context),
            Container(
                padding: const EdgeInsets.all(22.0),
                child: const Center(child: CircularProgressIndicator()))
          ],
        );
      case RequestStatus.failed:
      default:
        return Column(children: <Widget>[
          getCardTitle(context),
          Container(
              padding: const EdgeInsets.all(8.0),
              child: Text('Não foi possível obter informação',
                  style: Theme.of(context).textTheme.subtitle1))
        ]);
    }
  }

  /// Returns a widget for the title of the bus stops card
  Widget getCardTitle(context) {
    return Row(
      children: <Widget>[
        const Icon(Icons.directions_bus), // color lightgrey
        Text('STCP - Próximas Viagens',
            style: Theme.of(context).textTheme.subtitle1),
      ],
    );
  }

  /// Returns a widget for all the bus stops info
  Widget getBusStopsInfo(context, trips, stopConfig) {
    if (trips.length >= 1) {
      return Container(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: getEachBusStopInfo(context, trips, stopConfig),
          ));
    } else {
      return const Center(
        child: Text('Não há dados a mostrar neste momento',
            maxLines: 2, overflow: TextOverflow.fade),
      );
    }
  }

  /// Returns a list of widgets for each bus stop info that exists
  List<Widget> getEachBusStopInfo(context, trips, stopConfig) {
    final List<Widget> rows = <Widget>[];

    rows.add(const LastUpdateTimeStamp());

    trips.forEach((stopCode, tripList) {
      if (tripList.length > 0 && stopConfig[stopCode].favorited) {
        rows.add(Container(
            padding: const EdgeInsets.only(top: 12.0),
            child: BusStopRow(
              stopCode: stopCode,
              trips: tripList,
              singleTrip: true,
            )));
      }
    });

    return rows;
  }
}
