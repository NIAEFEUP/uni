import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/bus_stop.dart';
import 'package:uni/model/providers/lazy/bus_stop_provider.dart';
import 'package:uni/utils/drawer_items.dart';
import 'package:uni/view/bus_stop_next_arrivals/widgets/bus_stop_row.dart';
import 'package:uni/view/bus_stop_selection/bus_stop_selection.dart';
import 'package:uni/view/common_widgets/generic_card.dart';
import 'package:uni/view/common_widgets/last_update_timestamp.dart';
import 'package:uni/view/common_widgets/request_dependent_widget_builder.dart';
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
        if (busProvider.configuredBusStops.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  S.of(context).no_bus_stops,
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
        return RequestDependentWidgetBuilder(
          status: busProvider.status,
          builder: () =>
              getCardContent(context, busProvider.configuredBusStops),
          hasContentPredicate: busProvider.configuredBusStops.values
              .map((b) => b.trips)
              .flattened
              .toList()
              .isNotEmpty,
          onNullContent: Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  S.of(context).no_trips,
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
      },
    );
  }

  @override
  void onRefresh(BuildContext context) {
    Provider.of<BusStopProvider>(context, listen: false).forceRefresh(context);
  }

  /// Returns a list of widgets for each bus stop info that exists
  List<Widget> getEachBusStopInfo(
    BuildContext context,
    Map<String, BusStopData> stopData,
  ) {
    return stopData.entries
        .where(
          (busStop) =>
              busStop.value.trips.isNotEmpty && busStop.value.favorited,
        )
        .map(
          (busStop) => Container(
            padding: const EdgeInsets.only(top: 12),
            child: BusStopRow(
              stopCode: busStop.key,
              trips: busStop.value.trips,
              singleTrip: true,
            ),
          ),
        )
        .toList()
      ..add(
        <Widget>[const LastUpdateTimeStamp<BusStopProvider>()] as Container,
      );
  }

  /// Returns the bus stop info if it has trips
  Widget getCardContent(
    BuildContext context,
    Map<String, BusStopData> stopData,
  ) {
    return Column(
      children: <Widget>[
        getCardTitle(context),
        Container(
          padding: const EdgeInsets.all(4),
          child: Column(
            children: getEachBusStopInfo(
              context,
              stopData,
            ),
          ),
        ),
      ],
    );
  }

  /// Returns a widget for the title of the bus stops card
  Widget getCardTitle(BuildContext context) {
    return Row(
      children: <Widget>[
        const Icon(Icons.directions_bus), // color lightgrey
        Text(
          'STCP - Próximas Viagens',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}
