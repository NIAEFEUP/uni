import 'package:app_feup/model/entities/BusStop.dart';
import 'package:app_feup/view/Pages/BusStopSelectionPage.dart';
import 'package:app_feup/view/Pages/SecondaryPageView.dart';
import 'package:app_feup/view/Widgets/PageTitle.dart';
import '../../model/AppState.dart';
import 'package:flutter/material.dart';
import '../Theme.dart';
import 'package:app_feup/view/Widgets/BusStopRow.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:app_feup/view/Widgets/LastUpdateTimeStamp.dart';

class BusStopNextArrivalsPage extends SecondaryPageView{
  @override
  Widget getBody(BuildContext context){
    return StoreConnector<AppState, List<dynamic>>(
      converter: (store) => store.state.content['busstops'],
      builder: (context, busstops){
        return new NextArrivals(busstops);
      }
    );
  }
}

class NextArrivals extends StatefulWidget {
  final List<BusStop> busStops;

  NextArrivals(
    this.busStops
  );

  @override
  _NextArrivalsState createState() => new _NextArrivalsState(busStops);
}

class _NextArrivalsState extends State<NextArrivals> with SingleTickerProviderStateMixin{
  List<BusStop> busStops;
  TabController tabController;

  _NextArrivalsState(
      this.busStops
  );

  @override
  void initState() {
    super.initState();
    tabController = new TabController(vsync: this, length: busStops.length);
 //   var offset = (weekDay > 5) ? 0 : (weekDay - 1) % daysOfTheWeek.length;
  //  tabController.animateTo((tabController.index + offset));
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData queryData = MediaQuery.of(context);
    Color labelColor = Color.fromARGB(255, 0x50, 0x50, 0x50);

    return new Column(
      children: <Widget>[
        new PageTitle(name: 'Paragens'),
        new Container(
          padding: EdgeInsets.all(8.0),
          child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget> [
                new LastUpdateTimeStamp(),
                new IconButton(icon: new Icon(Icons.settings), onPressed: ()=> Navigator.pushNamed(context, '/ConfigurarParagens')),
              ]
          ),
        ),
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
          child: new TabBarView(
            controller: tabController,
            children: getEachBusStopInfo(context),
          ),
        ),
      ],
    );
  }

  List<Widget> createTabs(queryData) {
    List<Widget> tabs = List<Widget>();
    for( var i = 0; i < busStops.length; i++) {
      tabs.add(
          new Container(
            width:  queryData.size.width * 1/3,
            child: new Tab(text: busStops[i].stopCode),
          )
      );
    }
    return tabs;
  }

  List<Widget> getEachBusStopInfo(context){
    List<Widget> rows = new List<Widget>();

    for(int i = 0; i < busStops.length; i++){
      rows.add(
          new ListView(
              children: <Widget> [
                new Center(
                  child: new BusStopRow(
                          stopCode: busStops[i].stopCode,
                          stopCodeShow: false,
                          nextTrips: busStops[i].trips,
                        )
                )
              ]
          )
      );
    }
    return rows;
  }


/*
  Widget getCardContent(BuildContext context) {
    switch (StoreProvider.of<AppState>(context).state.content['busstopStatus']) {
      case RequestStatus.SUCCESSFUL:
        return Column(
            children: <Widget>[
              this.getBusStopsInfo(context)
            ]
        );
        break;
      case RequestStatus.BUSY:
        return Column(
          children: <Widget>[
            Center(child: CircularProgressIndicator())
          ],
        );
        break;
      case RequestStatus.FAILED:
        return Column(
            children : <Widget> [
              Text("Failed to get new information", style: Theme.of(context).textTheme.display1.apply(color: primaryColor)),
              this.getBusStopsInfo(context),
            ]
        );
        break;
    }
  }
*/
}
