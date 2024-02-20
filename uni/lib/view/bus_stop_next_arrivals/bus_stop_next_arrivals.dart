import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/bus_stop.dart';
import 'package:uni/model/providers/lazy/bus_stop_provider.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/bus_stop_next_arrivals/widgets/bus_stop_row.dart';
import 'package:uni/view/bus_stop_selection/bus_stop_selection.dart';
import 'package:uni/view/common_widgets/expanded_image_label.dart';
import 'package:uni/view/common_widgets/last_update_timestamp.dart';
import 'package:uni/view/common_widgets/pages_layouts/secondary/secondary.dart';
import 'package:uni/view/lazy_consumer.dart';

class BusStopNextArrivalsPage extends StatefulWidget {
  const BusStopNextArrivalsPage({super.key});

  @override
  State<StatefulWidget> createState() => BusStopNextArrivalsPageState();
}

/// Manages the 'Bus arrivals' section inside the user's personal area
class BusStopNextArrivalsPageState
    extends SecondaryPageViewState<BusStopNextArrivalsPage> {
  @override
  Widget getBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: const LastUpdateTimeStamp<BusStopProvider>(),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
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
          LazyConsumer<BusStopProvider, Map<String, BusStopData>>(
            builder: getArrivals,
            hasContent: (buses) => buses.isNotEmpty,
            onNullContent: Column(
              children: [
                ImageLabel(
                  imagePath: 'assets/images/bus.png',
                  label: S.of(context).no_bus,
                  labelTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute<BusStopNextArrivalsPage>(
                          builder: (context) => const BusStopSelectionPage(),
                        ),
                      ),
                      child: Text(S.of(context).add),
                    ),
                  ],
                ),
              ],
            ),
            contentLoadingWidget: Container(
              padding: const EdgeInsets.all(22),
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }

  Widget getArrivals(BuildContext context, Map<String, BusStopData> buses) {
    return NextArrivals(buses);
  }

  @override
  Future<void> onRefresh(BuildContext context) async {
    return Provider.of<BusStopProvider>(context, listen: false)
        .forceRefresh(context);
  }

  @override
  String? getTitle() => S.of(context).nav_title(NavigationItem.navStops.route);
}

class NextArrivals extends StatefulWidget {
  const NextArrivals(this.buses, {super.key});

  final Map<String, BusStopData> buses;

  @override
  NextArrivalsState createState() => NextArrivalsState();
}

/// Manages the 'Bus arrivals' section inside the user's personal area
class NextArrivalsState extends State<NextArrivals> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.buses.length,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: getContent(context),
      ),
    );
  }

  Widget getContent(BuildContext context) {
    final queryData = MediaQuery.of(context);

    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(),
            ),
          ),
          constraints: const BoxConstraints(maxHeight: 150),
          child: Material(
            child: TabBar(
              isScrollable: true,
              tabs: createTabs(queryData),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(bottom: 92),
            child: TabBarView(
              children: getEachBusStopInfo(context),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> createTabs(MediaQueryData queryData) {
    final tabs = <Widget>[];
    widget.buses.forEach((stopCode, stopData) {
      tabs.add(
        SizedBox(
          width: queryData.size.width /
              ((widget.buses.length < 3 ? widget.buses.length : 3) + 1),
          child: Tab(text: stopCode),
        ),
      );
    });
    return tabs;
  }

  /// Returns a list of widgets, for each bus stop configured by the user
  List<Widget> getEachBusStopInfo(BuildContext context) {
    final rows = <Widget>[];

    widget.buses.forEach((stopCode, stopData) {
      rows.add(
        Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 8,
                left: 22,
                right: 22,
              ),
              child: BusStopRow(
                stopCode: stopCode,
                trips: widget.buses[stopCode]?.trips ?? [],
                stopCodeShow: false,
              ),
            ),
          ],
        ),
      );
    });

    return rows;
  }
}
