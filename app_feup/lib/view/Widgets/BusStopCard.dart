import 'package:app_feup/view/Widgets/GenericCard.dart';
import '../../model/AppState.dart';
import 'package:flutter/material.dart';
import 'BusStopRow.dart';
import 'package:flutter_redux/flutter_redux.dart';


class BusStopCard extends StatelessWidget{

  final double padding = 4.0;

  BusStopCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<dynamic>>(
      converter: (store) => store.state.content['busstops'],
      builder: (context, busStops){
        return GenericCard(
            title: "Paragens",
            func: () => Navigator.pushReplacementNamed(context, '/Próximas viagens'),
            child: getCardContent(context, busStops)
        );
      },
    );
  }

  Widget getCardContent(BuildContext context, busStops){
    switch (StoreProvider.of<AppState>(context).state.content['busstops']){
      case RequestStatus.SUCCESSFUL:
        return busStops.length >= 1 ?
          Container(
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: this.getBusStopRows(context, busStops),
              ))

            : Center(
                child: Text("No stops to show at the moment"),
            );
      case RequestStatus.BUSY:
        return Center(child: CircularProgressIndicator());
        break;
      case RequestStatus.FAILED:
        if(busStops.length != 0)
          return Container(
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: this.getBusStopRows(context, busStops),
              )
          );
        else return Center(child: Text("Comunication error. Please check your internet connection."));
        break;
      default:
        return Container();
    }
  }

  List<Widget> getBusStopRows(context, busStops){
    List<Widget> rows = new List<Widget>();

    //rows.add(this.createTimeLapseRow(context));

    for(int i = 0; i < busStops.length; i++){
      rows.add(this.createRowFromBusStop(context, busStops[i]));
    }
    return rows;
  }

  Widget createRowFromBusStop(context, stop){
    return new BusStopRow(
        busStop : stop
    );
  }
}
