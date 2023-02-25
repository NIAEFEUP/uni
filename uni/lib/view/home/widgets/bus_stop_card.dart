import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/request_status.dart';
import 'package:uni/model/entities/bus_stop.dart';
import 'package:uni/model/entities/trip.dart';
import 'package:uni/model/providers/bus_stop_provider.dart';
import 'package:uni/utils/drawer_items.dart';
import 'package:uni/view/bus_stop_next_arrivals/widgets/bus_stop_row.dart';
import 'package:uni/view/bus_stop_selection/bus_stop_selection.dart';
import 'package:uni/view/common_widgets/generic_card.dart';
import 'package:uni/view/common_widgets/last_update_timestamp.dart';
import 'package:uni/view/common_widgets/request_dependent_widget_builder.dart';

/// Manages the bus stops card displayed on the user's personal area
class BusStopCard extends GenericCard {
  const BusStopCard.fromEditingInformation(Key key, bool editingMode,
      Function()? onDelete)
      : super.fromEditingInformation(key, editingMode, onDelete);

  @override
  String getTitle() => 'Autocarros';

  @override
  onClick(BuildContext context) =>
      Navigator.pushNamed(context, '/${DrawerItem.navStops.title}');

  @override
  Widget buildCardContent(BuildContext context) {
    return Consumer<BusStopProvider>(
        builder: (context, busProvider, _) {
          final trips = busProvider.currentBusTrips;
          return RequestDependentWidgetBuilder(
              context: context,
              status: busProvider.status,
              contentGenerator: generateBusStops,
              content: busProvider.currentBusTrips,
              contentChecker: trips.isNotEmpty,
              onNullContent: Container(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Configura os teus autocarros',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme
                              .of(context)
                              .textTheme
                              .subtitle2!
                              .apply()),
                      IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () =>
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (
                                        context) => const BusStopSelectionPage())),
                      )
                    ]),
              )
          );
        }
    );
  }

  Widget generateBusStops(busProvider, context) {
    return Column(children: <Widget>[
      getCardTitle(context),
      getBusStopsInfo(
          context,
          busProvider.currentBusTrips,
          busProvider.configuredBusStops
      )
    ]);
  }
  

  /// Returns a widget for the title of the bus stops card
  Widget getCardTitle(context) {
    return Row(
      children: <Widget>[
        const Icon(Icons.directions_bus), // color lightgrey
        Text('STCP - Próximas Viagens',
            style: Theme
                .of(context)
                .textTheme
                .subtitle1),
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
