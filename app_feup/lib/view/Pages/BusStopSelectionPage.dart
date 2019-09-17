import 'dart:async';
import 'dart:math';

import 'package:app_feup/controller/local_storage/AppBusStopDatabase.dart';
import 'package:app_feup/controller/networking/NetworkRouter.dart';
import 'package:app_feup/model/AppState.dart';
import 'package:app_feup/model/entities/Bus.dart';
import 'package:app_feup/model/entities/BusStop.dart';
import 'package:app_feup/redux/ActionCreators.dart';
import 'package:app_feup/redux/Actions.dart';
import 'package:app_feup/view/Widgets/PageTitle.dart';
import 'package:app_feup/view/Widgets/RowContainer.dart';
import 'package:flutter/material.dart';
import '../Pages/SecondaryPageView.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../Theme.dart' show darkGreyColor;


class BusStopSelectionPage extends SecondaryPageView {

  final double borderRadius = 15.0;
  final DateTime now = new DateTime.now();

  BusStopSelectionPage({Key key});

  @override
  Widget getBody(BuildContext context) {
    return StoreConnector<AppState, List<dynamic>>(
      converter: (store) => store.state.content['busstops'],
      builder: (context, busStops) {
        return stopsListing();
      },
    );
  }
}

class stopsListing extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _stopsListingState();
}

class _stopsListingState extends State<stopsListing>{
  List<BusStop> configuredStops = new List();
  AppBusStopDatabase db;
  List<String> suggestionsList = new List();

  _stopsListingState() {
    this.updateConfiguredStops();
  }

  Future<void> getDatabase() async {
    db = await AppBusStopDatabase();
  }

  Future<void> updateConfiguredStops() async {
    await getDatabase();
    List<BusStop> newStops = await db.busStops();
    this.setState((){
      configuredStops = newStops;
    });
    StoreProvider.of<AppState>(context).dispatch(new SetBusStopTripsAction(newStops));
  }

  List<Widget> getConfiguredStops() {
    List<Widget> stops = new List();
    for (BusStop stop in configuredStops) {
      stops.add(Text(stop.getStopCode()));
    }
    return stops;
  }

  Future deleteStop(BusStop stop) async {
    await db.removeBusStop(stop);
    this.updateConfiguredStops();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 12.0, right: 22.0),
            child: PageTitle(name: 'Paragens Configuradas')
          ),
          Column(
              children: List.generate(getConfiguredStops().length, (i) {
                return Container(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8.0, left: 40.0, right: 40.0),
                  child: RowContainer(
                      child: Container(
                          padding: EdgeInsets.only(left: 60.0, right: 60.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                getConfiguredStops()[i],
                                IconButton(
                                  icon: Icon(Icons.cancel),
                                  color: darkGreyColor,
                                  onPressed: () {
                                    deleteStop(configuredStops[i]);
                                  },
                                )
                              ]
                          )
                      )
                  )
                );
              })
          ),
          Align(
              alignment: Alignment.center,
              child: RaisedButton(
                  child: Text("Adicionar"),
                  onPressed: () {
                    showSearch(context: context, delegate: BusStopSearch());
                  }
              )
          )

        ]
    );
  }

  getSuggestedStops(String query) async { 
    final newSuggestions =  await NetworkRouter.getStopsByName(query);
    this.setState(() {
      this.suggestionsList = newSuggestions;
    });
  }
}

class BusStopSearch extends SearchDelegate<String> {
  List<String> suggestionsList = new List();
  AppBusStopDatabase db;  

  BusStopSearch() {
    this.getDatabase();
  }

  Future<void> getDatabase() async {
    db = await AppBusStopDatabase();
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: () {
      query = "";
    })];
  }

  @override
  Widget buildLeading(BuildContext context) { //Back arrow to go back to menu

    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        }
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  Widget getSuggestionList(BuildContext context) {
    return ListView.builder(
          itemBuilder: (context, index) => ListTile(
              onTap: () {
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      BusesForm busesForm = BusesForm(this.suggestionsList[index].splitMapJoin(RegExp(r"\[[A-Z0-9_]+\]"), onMatch: (m) => '${m.group(0).substring(1, m.group(0).length-1)}', onNonMatch: (m) => ''), db);
                      return AlertDialog(
                          title: Text("Seleciona os autocarros dos quais queres informação:"),
                          content: Container(
                            child: busesForm,
                            height: 200.0,
                            width: 100.0,
                          ),
                          actions: [
                            FlatButton(child: Text("Confirmar", style: Theme.of(context).textTheme.display1.apply(color: Theme.of(context).primaryColor),), onPressed: () async {
                              await busesForm.addBusStop();
                              StoreProvider.of<AppState>(context).dispatch(setUserBusStops(new Completer()));
                              Navigator.pop(context);
                            }),
                            FlatButton(child: Text("Cancelar", style: Theme.of(context).textTheme.display1.apply(color: Theme.of(context).primaryColor),), onPressed: () => Navigator.pop(context))
                          ]
                      );
                    }
                );
              },
              leading: Icon(Icons.directions_bus),
              title: Text(this.suggestionsList[index])
          ),
          itemCount: min(this.suggestionsList.length-1,9),
        );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: this.getStops(),
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot){
        if(snapshot.connectionState == ConnectionState.done && !snapshot.hasError)
          this.suggestionsList = snapshot.data;
        return getSuggestionList(context);
      }
    );
  }

  Future<List<String>> getStops() async {
    if(query != "") {
      return NetworkRouter.getStopsByName(query);
    }
    return [];
  }
}

class BusesForm extends StatefulWidget {
  String stop;
  BusStop stopToAdd;
  AppBusStopDatabase db;
  _BusesFormState state;

  BusesForm(this.stop, this.db) {
    state = _BusesFormState(stop, db);
  }

  Future<void> addBusStop() async {
    await db.addBusStop(stopToAdd);
    return;
  }

  @override
  State<StatefulWidget> createState() {return state;}

}

class _BusesFormState extends State<BusesForm>{
  String stop;
  AppBusStopDatabase db;
  List<Bus> buses = new List();
  List<bool> busesToAdd = List<bool>.filled(20, false);

  _BusesFormState(this.stop, this.db);

  @override
  void initState() {
    updateBuses();
    super.initState();
  }

  void updateBuses() async {
    List<Bus> buses = await NetworkRouter.getBusesStoppingAt(stop);
    this.setState((){
      this.buses = buses;
      busesToAdd.fillRange(0, buses.length, false);
    });
  }

  @override
  Widget build(BuildContext context) {
    updateBusStop();
    return ListView(
      children: List.generate(buses.length, (i) {
        return Row(
            children: <Widget>[
              Text('[${buses[i].busCode}] ${buses[i].destination.length > 20 ? buses[i].destination.substring(0,20) + "..." : buses[i].destination}'),
              Checkbox(value: busesToAdd[i],
                  onChanged: (value) {
                    setState(() {
                      busesToAdd[i] = value;
                    });
                  },
                activeColor: Theme.of(context).primaryColor
              ),
            ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        );
      })
    );
  }

  void updateBusStop() {
    List<Bus> newBuses = new List();
    for(int i = 0; i < buses.length; i++) {
      if(busesToAdd[i]) {
        newBuses.add(buses[i]);
      }
    }
    BusStop newStop = BusStop.secConstructor(stop, newBuses);
    this.widget.stopToAdd = newStop;
  }
}