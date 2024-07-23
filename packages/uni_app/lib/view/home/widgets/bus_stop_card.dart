import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/bus_stop.dart';
import 'package:uni/model/providers/lazy/bus_stop_provider.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/bus_stop_next_arrivals/widgets/bus_stop_row.dart';
import 'package:uni/view/bus_stop_selection/bus_stop_selection.dart';
import 'package:uni/view/common_widgets/generic_card.dart';
import 'package:uni/view/common_widgets/last_update_timestamp.dart';
import 'package:uni/view/lazy_consumer.dart';

/// Manages the bus stops card displayed on the user's personal area
class BusStopCard extends GenericCard {
  BusStopCard({super.key});

  const BusStopCard.fromEditingInformation(
    super.key, {
    required super.editingMode,
    super.onDelete,
  }) : super.fromEditingInformation();

  @override
  String getTitle(BuildContext context) =>
      S.of(context).nav_title(NavigationItem.navStops.route);

  @override
  Future<Object?> onClick(BuildContext context) =>
      Navigator.pushNamed(context, '/${NavigationItem.navStops.route}');

  @override
  Widget buildCardContent(BuildContext context) {
    return LazyConsumer<BusStopProvider, Map<String, BusStopData>>(
      contentLoadingWidget: Column(
        children: <Widget>[
          getCardTitle(context),
          Container(
            padding: const EdgeInsets.all(22),
            child: const Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
      builder: (context, stopData) => Column(
        children: <Widget>[
          getCardTitle(context),
          getBusStopsInfo(context, stopData),
        ],
      ),
      hasContent: (busStops) => busStops.isNotEmpty,
      onNullContent: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              S.of(context).buses_personalize,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall!.apply(),
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<BusStopSelectionPage>(
                  builder: (context) => const BusStopSelectionPage(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onRefresh(BuildContext context) {
    Provider.of<BusStopProvider>(context, listen: false).forceRefresh(context);
  }
}

/// Returns a widget for the title of the bus stops card
Widget getCardTitle(BuildContext context) {
  return Row(
    children: <Widget>[
      const Icon(Icons.directions_bus),
      Text(
        S.of(context).stcp_stops,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    ],
  );
}

/// Returns a widget for all the bus stops info
Widget getBusStopsInfo(
  BuildContext context,
  Map<String, BusStopData> stopData,
) {
  if (stopData.isNotEmpty) {
    return Container(
      padding: const EdgeInsets.all(4),
      child: Column(
        children: getEachBusStopInfo(context, stopData),
      ),
    );
  } else {
    return Center(
      child: Text(
        S.of(context).no_data,
        maxLines: 2,
        overflow: TextOverflow.fade,
      ),
    );
  }
}

/// Returns a list of widgets for each bus stop info that exists
List<Widget> getEachBusStopInfo(
  BuildContext context,
  Map<String, BusStopData> stopData,
) {
  final rows = <Widget>[
    const LastUpdateTimeStamp<BusStopProvider>(),
  ];

  stopData.forEach((stopCode, stopInfo) {
    if (stopInfo.trips.isNotEmpty && stopInfo.favorited) {
      rows.add(
        Container(
          padding: const EdgeInsets.only(top: 12),
          child: BusStopRow(
            stopCode: stopCode,
            trips: stopInfo.trips,
            singleTrip: true,
          ),
        ),
      );
    }
  });

  return rows;
}
