import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/bus_stop.dart';
import 'package:uni/model/providers/lazy/bus_stop_provider.dart';
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
    super.key, {
    required super.editingMode,
    super.onDelete,
  }) : super.fromEditingInformation();

  @override
  String getTitle(BuildContext context) =>
      S.of(context).nav_title(DrawerItem.navStops.title);

  @override
  Future<Object?> onClick(BuildContext context) =>
      Navigator.pushNamed(context, '/${DrawerItem.navStops.title}');

  @override
  Widget buildCardContent(BuildContext context) {
    return LazyConsumer<BusStopProvider>(
      builder: (context, busProvider) {
        return getCardContent(
          context,
          busProvider.state!,
          busProvider.requestStatus,
        );
      },
    );
  }

  @override
  void onRefresh(BuildContext context) {
    Provider.of<BusStopProvider>(context, listen: false).forceRefresh(context);
  }
}

/// Returns a widget with the bus stop card final content
Widget getCardContent(
  BuildContext context,
  Map<String, BusStopData> stopData,
  RequestStatus busStopStatus,
) {
  switch (busStopStatus) {
    case RequestStatus.successful:
      if (stopData.isNotEmpty) {
        return Column(
          children: <Widget>[
            getCardTitle(context),
            getBusStopsInfo(context, stopData),
          ],
        );
      } else {
        return Container(
          padding: const EdgeInsets.all(8),
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
        );
      }
    case RequestStatus.busy:
      return Column(
        children: <Widget>[
          getCardTitle(context),
          Container(
            padding: const EdgeInsets.all(22),
            child: const Center(child: CircularProgressIndicator()),
          ),
        ],
      );
    case RequestStatus.failed:
    case RequestStatus.none:
      return Column(
        children: <Widget>[
          getCardTitle(context),
          Container(
            padding: const EdgeInsets.all(8),
            child: Text(
              S.of(context).bus_error,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      );
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
  final rows = <Widget>[const LastUpdateTimeStamp<BusStopProvider>()];

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
