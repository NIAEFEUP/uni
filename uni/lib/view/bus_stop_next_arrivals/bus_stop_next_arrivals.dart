import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/request_status.dart';
import 'package:uni/model/entities/bus_stop.dart';
import 'package:uni/utils/drawer_items.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/providers/bus_stop_provider.dart';
import 'package:uni/view/bus_stop_next_arrivals/widgets/bus_stop_row.dart';
import 'package:uni/view/bus_stop_selection/bus_stop_selection.dart';
import 'package:uni/view/common_widgets/last_update_timestamp.dart';
import 'package:uni/view/common_widgets/page_title.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';

class BusStopNextArrivalsPage extends StatefulWidget {
  const BusStopNextArrivalsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => BusStopNextArrivalsPageState();
}

/// Manages the 'Bus arrivals' section inside the user's personal area
class BusStopNextArrivalsPageState
    extends GeneralPageViewState<BusStopNextArrivalsPage> {
  @override
  Widget getBody(BuildContext context) {
    return Consumer<BusStopProvider>(
        builder: (context, busProvider, _) => ListView(children: [
              NextArrivals(
                  busProvider.configuredBusStops, busProvider.status)
            ]));
  }
}

class NextArrivals extends StatefulWidget {
  //final Map<String, List<Trip>> trips;
  final Map<String, BusStopData> buses;
  final RequestStatus busStopStatus;

  const NextArrivals(this.buses, this.busStopStatus,
      {super.key});

  @override
  NextArrivalsState createState() => NextArrivalsState();
}

/// Manages the 'Bus arrivals' section inside the user's personal area
class NextArrivalsState extends State<NextArrivals> {
  @override
  Widget build(BuildContext context) {
    Widget contentBuilder() {
    switch (widget.busStopStatus) {
      case RequestStatus.successful:
        return SizedBox(
            height: MediaQuery
                .of(context)
                .size
                .height,
            child: Column(children: requestSuccessful(context)));
      case RequestStatus.busy:
        return SizedBox(
            height: MediaQuery
                .of(context)
                .size
                .height,
            child: Column(children: requestBusy(context)));
      case RequestStatus.failed:
        return SizedBox(
            height: MediaQuery
                .of(context)
                .size
                .height,
            child: Column(children: requestFailed(context)));
      default:
        return Container();
    }
  }
    return DefaultTabController(length: widget.buses.length, child: contentBuilder());
  }

  /// Returns a list of widgets for a successfull request
  List<Widget> requestSuccessful(context) {
    final List<Widget> result = <Widget>[];

    result.addAll(getHeader(context));

    if (widget.buses.isNotEmpty) {
      result.addAll(getContent(context));
    } else {
      result.add(Text('Não existe nenhuma paragem configurada',
          style: Theme.of(context).textTheme.titleLarge));
    }

    return result;
  }

  /// TODO: Is this ok?
  /// Returns a list of widgets for a busy request
  List<Widget> requestBusy(BuildContext context) {
    final List<Widget> result = <Widget>[];

    result.add(getPageTitle());
    result.add(Container(
        padding: const EdgeInsets.all(22.0),
        child: const Center(child: CircularProgressIndicator())));

    return result;
  }

  Container getPageTitle() {
    return Container(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: PageTitle(name: S.of(context).nav_title(DrawerItem.navStops.title)));
  }

  /// Returns a list of widgets for a failed request
  List<Widget> requestFailed(BuildContext context) {
    final List<Widget> result = <Widget>[];

    result.addAll(getHeader(context));
    result.add(Container(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Text('Não foi possível obter informação',
            maxLines: 2,
            overflow: TextOverflow.fade,
            style: Theme.of(context).textTheme.titleMedium)));

    return result;
  }

  List<Widget> getHeader(context) {
    return [
      getPageTitle(),
      Container(
        padding: const EdgeInsets.all(8.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(left: 10.0),
                child: const LastUpdateTimeStamp(),
              ),
              IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BusStopSelectionPage())))
            ]),
      )
    ];
  }

  List<Widget> getContent(BuildContext context) {
    final MediaQueryData queryData = MediaQuery.of(context);

    return [
      Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1.0),
          ),
        ),
        constraints: const BoxConstraints(maxHeight: 150.0),
        child: Material(
          child: TabBar(
            isScrollable: true,
            tabs: createTabs(queryData),
          ),
        ),
      ),
      Expanded(
        child: Container(
          padding: const EdgeInsets.only(bottom: 92.0),
          child: TabBarView(
            children: getEachBusStopInfo(context),
          ),
        ),
      )
    ];
  }

  List<Widget> createTabs(queryData) {
    final List<Widget> tabs = <Widget>[];
    widget.buses.forEach((stopCode, stopData) {
      tabs.add(SizedBox(
        width: queryData.size.width /
            ((widget.buses.length < 3 ? widget.buses.length : 3) + 1),
        child: Tab(text: stopCode),
      ));
    });
    return tabs;
  }

  /// Returns a list of widgets, for each bus stop configured by the user
  List<Widget> getEachBusStopInfo(context) {
    final List<Widget> rows = <Widget>[];

    widget.buses.forEach((stopCode, stopData) {
      rows.add(ListView(children: <Widget>[
        Container(
            padding: const EdgeInsets.only(
                top: 8.0, bottom: 8.0, left: 22.0, right: 22.0),
            child: BusStopRow(
              stopCode: stopCode,
              trips: widget.buses[stopCode]?.trips ?? [],
              stopCodeShow: false,
            ))
      ]));
    });

    return rows;
  }
}
