import 'package:flutter/material.dart';
import 'package:uni/model/entities/bus_stop.dart';
import 'package:uni/model/providers/bus_stop_provider.dart';
import 'package:uni/model/request_status.dart';
import 'package:uni/utils/drawer_items.dart';
import 'package:uni/view/bus_stop_next_arrivals/widgets/bus_stop_row.dart';
import 'package:uni/view/bus_stop_selection/bus_stop_selection.dart';
import 'package:uni/view/common_widgets/generic_card.dart';
import 'package:uni/view/common_widgets/last_update_timestamp.dart';
import 'package:uni/view/lazy_consumer.dart';

/// Manages the bus stops card displayed on the user's personal area
class BusStopCard extends GenericCard {
  const BusStopCard.fromEditingInformation(
      Key key, bool editingMode, Function()? onDelete)
      : super.fromEditingInformation(key, editingMode, onDelete);

  @override
  String getTitle() => 'Autocarros';

  @override
  onClick(BuildContext context) =>
      Navigator.pushNamed(context, '/${DrawerItem.navStops.title}');

  @override
  Widget buildCardContent(BuildContext context) {
    return LazyConsumer<BusStopProvider>(
      builder: (context, busProvider) {
        return getCardContent(
            context, busProvider.configuredBusStops, busProvider.status);
      },
    );
  }
}

/// Returns a widget with the bus stop card final content
Widget getCardContent(
    BuildContext context, Map<String, BusStopData> stopData, busStopStatus) {
  switch (busStopStatus) {
    case RequestStatus.successful:
      if (stopData.isNotEmpty) {
        return Column(children: <Widget>[
          getCardTitle(context),
          getBusStopsInfo(context, stopData)
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
                    style: Theme.of(context).textTheme.titleSmall!.apply()),
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BusStopSelectionPage())),
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
                style: Theme.of(context).textTheme.titleMedium))
      ]);
  }
}

/// Returns a widget for the title of the bus stops card
Widget getCardTitle(context) {
  return Row(
    children: <Widget>[
      const Icon(Icons.directions_bus), // color lightgrey
      Text('STCP - Próximas Viagens',
          style: Theme.of(context).textTheme.titleMedium),
    ],
  );
}

/// Returns a widget for all the bus stops info
Widget getBusStopsInfo(context, Map<String, BusStopData> stopData) {
  if (stopData.isNotEmpty) {
    return Container(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: getEachBusStopInfo(context, stopData),
        ));
  } else {
    return const Center(
      child: Text('Não há dados a mostrar neste momento',
          maxLines: 2, overflow: TextOverflow.fade),
    );
  }
}

/// Returns a list of widgets for each bus stop info that exists
List<Widget> getEachBusStopInfo(context, Map<String, BusStopData> stopData) {
  final List<Widget> rows = <Widget>[];

  rows.add(const LastUpdateTimeStamp());

  stopData.forEach((stopCode, stopInfo) {
    if (stopInfo.trips.isNotEmpty && stopInfo.favorited) {
      rows.add(Container(
          padding: const EdgeInsets.only(top: 12.0),
          child: BusStopRow(
            stopCode: stopCode,
            trips: stopInfo.trips,
            singleTrip: true,
          )));
    }
  });

  return rows;
}
