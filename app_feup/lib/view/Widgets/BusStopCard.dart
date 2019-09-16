import 'package:app_feup/view/Widgets/GenericCard.dart';
import '../../model/AppState.dart';
import 'package:flutter/material.dart';
import '../Theme.dart';
import 'BusStopRow.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'LastUpdateTimeStamp.dart';
import 'RowContainer.dart';


class BusStopCard extends GenericCard {

  BusStopCard.fromEditingInformation(Key key, bool editingMode, Function onDelete):super.fromEditingInformation(key, editingMode, onDelete);

  @override
  String getTitle() => "Paragens";

  @override
  onClick(BuildContext context) => Navigator.pushNamed(context, '/Paragens');

  @override
  Widget buildCardContent(BuildContext context) {
    return StoreConnector<AppState, List<dynamic>>(
        converter: (store) => store.state.content['busstops'],
        builder: (context, busstops) => getCardContent(context, busstops)
    );
  }

  Widget getCardContent(BuildContext context, busStops) {
    switch (StoreProvider.of<AppState>(context).state.content['busstopStatus']) {
      case RequestStatus.SUCCESSFUL:
        if(busStops.length > 0){
          return Column(
              children: <Widget>[
                this.getCardTitle(context),
                this.getBusStopsInfo(context, busStops)
              ]
          );
        } else{
          return new Container(
            padding: EdgeInsets.all(8.0),
            child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget> [
                  Text("Configura as tuas paragens", style: Theme.of(context).textTheme.display1.apply(color: primaryColor)),
                  IconButton(icon: new Icon(Icons.settings), onPressed: ()=> Navigator.pushNamed(context, '/ConfigurarParagens')),
                ]
            ),
          );
        }

        break;
      case RequestStatus.BUSY:
        return Column(
          children: <Widget>[
            this.getCardTitle(context),
            new Container(
                padding: EdgeInsets.all(22.0),
                child: Center(child: CircularProgressIndicator())
            )
          ],
        );
        break;
      case RequestStatus.FAILED:
        return Column(
            children : <Widget> [
              this.getCardTitle(context),
              new Container(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Failed to get new information", style: Theme.of(context).textTheme.display1.apply(color: primaryColor))
              ),
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
          child: Text("No information to show at the moment"),
        );
  }

  List<Widget> getEachBusStopInfo(context, busStops){
    List<Widget> rows = new List<Widget>();

    rows.add(new LastUpdateTimeStamp());

    int num_max_stops = 6;

    for(int i = 0; i < busStops.length && num_max_stops > 0; i++){
      if (busStops[i].trips.length > 0) {
        rows.add(
            new Container(
              padding: EdgeInsets.only(top: 12.0),
              child: new RowContainer(
                child: new BusStopRow(
                    busStop: busStops[i],
                    singleTrip: true,
                )
              )
            )
        );

        num_max_stops++;
      }
    }
    return rows;
  }
}
