import 'package:uni/controller/local_storage/AppBusStopDatabase.dart';
import 'package:uni/model/AppState.dart';
import 'package:uni/model/entities/BusStop.dart';
import 'package:uni/view/Pages/UnnamedPageView.dart';
import 'package:uni/view/Widgets/BusStopSearch.dart';
import 'package:uni/view/Widgets/BusStopSelectionRow.dart';
import 'package:uni/view/Widgets/PageTitle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class BusStopSelectionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BusStopSelectionPageState();
}

class BusStopSelectionPageState extends UnnamedPageView {
  final double borderRadius = 15.0;
  final DateTime now = new DateTime.now();

  final AppBusStopDatabase db = AppBusStopDatabase();
  final Map<String, BusStopData> configuredStops = new Map();
  final List<String> suggestionsList = new List();

  List<Widget> getStopsTextList() {
    List<Widget> stops = new List();
    configuredStops.forEach((stopCode, stopData) {
      stops.add(Text(stopCode));
    });
    return stops;
  }

  @override
  Widget getBody(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return StoreConnector<AppState, Map<String, BusStopData>>(
      converter: (store) => store.state.content['configuredBusStops'],
      builder: (context, busStops) {
        List<Widget> rows = new List();
        busStops.forEach((stopCode, stopData) =>
            rows.add(BusStopSelectionRow(stopCode, stopData)));
        return ListView(
            padding: EdgeInsets.only(bottom: 20,),
            children: <Widget>[
              Container(child: PageTitle(name: 'Paragens Configuradas')),
              Container(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                      "As paragens favoritas serão apresentadas no widget \"Paragens\" dos favoritos. As restantes serão apresentadas apenas na página.",
                      textAlign: TextAlign.center)),
              Column(children: rows),
              Container(
                  padding: EdgeInsets.only(left: width * 0.20, right: width * 0.20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RaisedButton(
                          onPressed: () => showSearch(
                              context: context, delegate: BusStopSearch()),
                          color: Theme.of(context).primaryColor,
                          padding: const EdgeInsets.all(0.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(12.0),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(15.0),
                            child: Text("Adicionar",
                                style: Theme.of(context)
                                    .textTheme
                                    .display1
                                    .apply(color: Colors.white, fontSizeDelta: -2)),
                          ),
                        ),
                        RaisedButton(
                          onPressed: () => Navigator.pop(context),
                          color: Theme.of(context).primaryColor,
                          padding: const EdgeInsets.all(0.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(12.0),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(15.0),
                            child: Text("Concluído",
                                style: Theme.of(context)
                                    .textTheme
                                    .display1
                                    .apply(color: Colors.white, fontSizeDelta: -2)),
                          ),
                        ),
                      ]))
            ]);
      },
    );
  }
}
