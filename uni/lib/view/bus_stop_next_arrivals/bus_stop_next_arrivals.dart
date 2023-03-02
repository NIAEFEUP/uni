import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/bus_stop.dart';
import 'package:uni/model/entities/trip.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';
import 'package:uni/view/common_widgets/random_image.dart';
import 'package:uni/view/bus_stop_selection/bus_stop_selection.dart';
import 'package:uni/view/bus_stop_next_arrivals/widgets/bus_stop_row.dart';
import 'package:uni/view/common_widgets/last_update_timestamp.dart';
import 'package:uni/view/common_widgets/page_title.dart';

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
    return StoreConnector<
            AppState,
            Tuple3<Map<String, List<Trip>>, Map<String, BusStopData>,
                RequestStatus>?>(
        converter: (store) => Tuple3(
            store.state.content['currentBusTrips'],
            store.state.content['configuredBusStops'],
            store.state.content['busStopStatus']),
        builder: (context, busStops) {
          return ListView(children: [
            NextArrivals(busStops?.item1 ?? {}, busStops?.item2 ?? {},
                busStops?.item3 ?? RequestStatus.none)
          ]);
        });
  }
}

class NextArrivals extends StatefulWidget {
  final Map<String, List<Trip>> trips;
  final Map<String, BusStopData> busConfig;
  final RequestStatus busStopStatus;

  const NextArrivals(this.trips, this.busConfig, this.busStopStatus,
      {super.key});

  @override
  NextArrivalsState createState() => NextArrivalsState();
}

/// Manages the 'Bus arrivals' section inside the user's personal area
class NextArrivalsState extends State<NextArrivals>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;

  NextArrivalsState();

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: widget.busConfig.length);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.busStopStatus) {
      case RequestStatus.successful:
        return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(children: requestSuccessful(context)));
      case RequestStatus.busy:
        return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(children: requestBusy(context)));
      case RequestStatus.failed:
        return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(children: requestFailed(context)));
      default:
        return Container();
    }
  }

  /// Returns a list of widgets for a successfull request
  List<Widget> requestSuccessful(context) {
    final List<Widget> result = <Widget>[];
    final List<String> images = ['assets/images/bus.png', 'assets/images/flat_bus.png'];

    result.addAll(getHeader(context));

    if (widget.busConfig.isNotEmpty) {
      result.addAll(getContent(context));
    } else {
      result.add(
        RotatingImage(
            imagePaths: images,
            width: 250,
            height: 250,
        ),
      );
      result.add(
        TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
          ),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const BusStopSelectionPage())),
          child: const Text('Adiciona as tuas paragens', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color.fromARGB(255, 0x75, 0x17, 0x1e))),
        ),);
      result.add(
        const Text('\nNão percas nenhum autocarro', style: TextStyle(fontSize: 15)
        ),);
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
        child: const PageTitle(name: 'Autocarros'));
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
            style: Theme.of(context).textTheme.subtitle1)));

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
            controller: tabController,
            isScrollable: true,
            tabs: createTabs(queryData),
          ),
        ),
      ),
      Expanded(
        child: Container(
          padding: const EdgeInsets.only(bottom: 92.0),
          child: TabBarView(
            controller: tabController,
            children: getEachBusStopInfo(context),
          ),
        ),
      )
    ];
  }

  List<Widget> createTabs(queryData) {
    final List<Widget> tabs = <Widget>[];
    widget.busConfig.forEach((stopCode, stopData) {
      tabs.add(SizedBox(
        width: queryData.size.width /
            ((widget.busConfig.length < 3 ? widget.busConfig.length : 3) + 1),
        child: Tab(text: stopCode),
      ));
    });
    return tabs;
  }

  /// Returns a list of widgets, for each bus stop configured by the user
  List<Widget> getEachBusStopInfo(context) {
    final List<Widget> rows = <Widget>[];

    widget.busConfig.forEach((stopCode, stopData) {
      rows.add(ListView(children: <Widget>[
        Container(
            padding: const EdgeInsets.only(
                top: 8.0, bottom: 8.0, left: 22.0, right: 22.0),
            child: BusStopRow(
              stopCode: stopCode,
              trips: widget.trips[stopCode] ?? [],
              stopCodeShow: false,
            ))
      ]));
    });

    return rows;
  }
}
