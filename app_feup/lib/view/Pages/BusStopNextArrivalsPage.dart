import 'package:uni/model/entities/BusStop.dart';
import 'package:uni/model/entities/Trip.dart';
import 'package:uni/view/Pages/BusStopSelectionPage.dart';
import 'package:uni/view/Widgets/PageTitle.dart';
import 'package:tuple/tuple.dart';
import '../../model/AppState.dart';
import 'package:flutter/material.dart';
import 'package:uni/view/Widgets/BusStopRow.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:uni/view/Widgets/LastUpdateTimeStamp.dart';

import '../Theme.dart';
import 'SecondaryPageView.dart';

class BusStopNextArrivalsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BusStopNextArrivalsPageState();
}

class BusStopNextArrivalsPageState extends SecondaryPageViewState {
  @override
  Widget getBody(BuildContext context){
    return StoreConnector<AppState, Tuple3<Map<String, List<Trip>>, Map<String, BusStopData>, RequestStatus>> (
        converter: (store) => Tuple3(store.state.content['currentBusTrips'], store.state.content['configuredBusStops'], store.state.content['busstopStatus']),
        builder: (context, busstops) {
          return new ListView(children: [NextArrivals(busstops.item1, busstops.item2, busstops.item3)]);
        }
    );
  }
}

class NextArrivals extends StatefulWidget {
  final Map<String, List<Trip>> trips;
  final Map<String, BusStopData> busConfig;
  final RequestStatus busStopStatus;

  NextArrivals(this.trips, this.busConfig, this.busStopStatus);

  @override
  _NextArrivalsState createState() => new _NextArrivalsState(trips, busConfig, busStopStatus);
}

class _NextArrivalsState extends State<NextArrivals> with SingleTickerProviderStateMixin{
  final Map<String, List<Trip>> trips;
  final Map<String, BusStopData> busConfig;
  final RequestStatus busStopStatus;
  TabController tabController;

  _NextArrivalsState(this.trips, this.busConfig, this.busStopStatus);

  @override
  void initState() {
    super.initState();
    tabController = new TabController(vsync: this, length: busConfig.length);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (busStopStatus) {
      case RequestStatus.SUCCESSFUL:
        return new Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
                children: this.requestSuccessful(context)
            )
        );
        break;
      case RequestStatus.BUSY:
        return new Container(
            height: MediaQuery.of(context).size.height,
            child:Column(
                children: this.requestBusy(context)
            )
        );
        break;
      case RequestStatus.FAILED:
        return new Container(
            height: MediaQuery.of(context).size.height,
            child:Column(
                children: this.requestFailed(context)
            )
        );
        break;
      default:
        return new Container();
        break;
    }
  }

  List<Widget> requestSuccessful(context){
    List<Widget> result = new List<Widget>();

    result.addAll(this.getHeader(context));

    if(busConfig.length > 0)
      result.addAll(this.getContent(context));
    else{
      result.add(
          new Container(
              child: Text('Não se encontram configuradas paragens', style: Theme.of(context).textTheme.display1.apply(color: greyTextColor))
          )
      );
    }

    return result;
  }

  List<Widget> requestBusy(BuildContext context) {
    List<Widget> result = new List<Widget>();

    result.add(getPageTitle());
    result.add(
        new Container(
            padding: EdgeInsets.all(22.0),
            child: Center(child: CircularProgressIndicator())
        )
    );

    return result;
  }

  Container getPageTitle() {
    return Container(
        padding: EdgeInsets.only(bottom: 12.0),
        child: PageTitle(name: 'Paragens')
    );
  }

  List<Widget> requestFailed(BuildContext context) {
    List<Widget> result = new List<Widget>();

    result.addAll(this.getHeader(context));
    result.add(
        new Container(
            padding: EdgeInsets.only(bottom: 12.0),
            child: Text("Não foi possível obter informação", maxLines: 2, overflow: TextOverflow.fade, style: Theme.of(context).textTheme.display1.apply(color: primaryColor))
        )
    );

    return result;
  }

  List<Widget> getHeader(context) {
    return [
      getPageTitle(),
      new Container(
        padding: EdgeInsets.all(8.0),
        child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget> [
              new Container(
                padding:EdgeInsets.only(left: 10.0),
                child: new LastUpdateTimeStamp(),
              ),
              new IconButton(
                  icon: new Icon(Icons.edit),
                  color: Theme.of(context).primaryColor,
                  onPressed: ()=> Navigator.push(context, new MaterialPageRoute(builder: (context) => new BusStopSelectionPage()))
              )
            ]
        ),
      )
    ];
  }

  List<Widget> getContent(BuildContext context) {
    final MediaQueryData queryData = MediaQuery.of(context);
    Color labelColor = Color.fromARGB(255, 0x50, 0x50, 0x50);

    return [
      new Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1.0, color: Colors.grey),
          ),
        ),
        constraints: BoxConstraints(maxHeight: 150.0),
        child: new Material(
          color: Colors.white,
          child: new TabBar(
            controller: tabController,
            isScrollable: true,
            unselectedLabelColor: labelColor,
            labelColor: labelColor,
            indicatorWeight: 3.0,
            indicatorColor: Theme.of(context).primaryColor,
            labelPadding: EdgeInsets.all(0.0),
            tabs: createTabs(queryData),
          ),
        ),
      ),
      new Expanded(
        child: Container(
          padding: EdgeInsets.only(bottom: 92.0),
          child: new TabBarView(
            controller: tabController,
            children: getEachBusStopInfo(context),
          ),
        ),
      )
    ];
  }

  List<Widget> createTabs(queryData) {
    List<Widget> tabs = List<Widget>();
    busConfig.forEach((stopCode, stopData) {
      tabs.add(
          new Container(
            width:  queryData.size.width / (busConfig.length < 3 ? busConfig.length : 3 ),
            child: new Tab(text: stopCode),
          )
      );
    });
    return tabs;
  }

  List<Widget> getEachBusStopInfo(context){
    List<Widget> rows = new List<Widget>();

    busConfig.forEach((stopCode, stopData) {
      rows.add(
          new ListView(
              children: <Widget>[
                new Container(
                    padding: EdgeInsets.only(
                        top: 8.0, bottom: 8.0, left: 22.0, right: 22.0),
                    child: new BusStopRow(
                      stopCode: stopCode,
                      trips: trips[stopCode],
                      stopCodeShow: false,
                    )
                )
              ]
          )
      );
    });

    return rows;
  }
}
