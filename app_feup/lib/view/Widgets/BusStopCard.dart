import 'package:app_feup/view/Widgets/GenericCard.dart';
import '../../model/AppState.dart';
import 'package:flutter/material.dart';
import '../Theme.dart';
import 'BusStopRow.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'LastUpdateTimeStamp.dart';


class BusStopCard extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<dynamic>>(
      converter: (store) => store.state.content['busstops'],
      builder: (context, busstops){
        return GenericCard(
            title: "Paragens",
            func: () => Navigator.pushNamed(context, '/Paragens'),
            child: getCardContent(context, busstops)
        );
      },
    );
  }

  Widget getCardContent(BuildContext context, busStops) {
    switch (StoreProvider.of<AppState>(context).state.content['busstopStatus']) {
      case RequestStatus.SUCCESSFUL:
        return Column(
            children: <Widget>[
              this.getCardTitle(context),
              this.getBusStopsInfo(context, busStops)
            ]
        );
        break;
      case RequestStatus.BUSY:
        return Column(
          children: <Widget>[
            this.getCardTitle(context),
            Center(child: CircularProgressIndicator())
          ],
        );
        break;
      case RequestStatus.FAILED:
        return Column(
            children : <Widget> [
              this.getCardTitle(context),
              Text("Failed to get new information", style: Theme.of(context).textTheme.display1.apply(color: primaryColor)),
              this.getBusStopsInfo(context, busStops),
            ]
        );
        break;
    }
  }

  Widget getCardTitle(context){
    return Row(
      children: <Widget>[
        Icon(Icons.directions_bus),
        Text('STCP - Próximas Viagens', style: Theme.of(context).textTheme.display1.apply(color: primaryColor))
      ],
    );
  }

  Widget getBusStopsInfo(context, busStops){
    if (busStops.length >= 1)
      return
        Container(
            padding: EdgeInsets.all(4.0),
            child: new Column(
              children: this.getEachBusStopInfo(context, busStops),
            ));
    else
      return
        Center(
          child: Text("No stops to show at the moment"),
        );
  }

  List<Widget> getEachBusStopInfo(context, busStops){
    List<Widget> rows = new List<Widget>();
    var size = busStops.length;

    rows.add(new LastUpdateTimeStamp());

    for(int i = 0; i < busStops.length; i++){
      rows.add(new BusStopRow(
        stopCode: busStops[i].stopCode,
        nextTrips: busStops[i].trips.sublist(0, 1),
      ));
    }
    return rows;
  }
}
