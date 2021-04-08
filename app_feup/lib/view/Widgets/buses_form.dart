import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/bus.dart';
import 'package:uni/model/entities/bus_stop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

class BusesForm extends StatefulWidget {
  final String stopCode;
  final Function updateStopCallback;

  BusesForm(this.stopCode, this.updateStopCallback);

  @override
  State<StatefulWidget> createState() {
    return _BusesFormState(stopCode, updateStopCallback);
  }
}

class _BusesFormState extends State<BusesForm> {
  final String stopCode;
  final Function updateStopCallback;
  List<Bus> buses = [];
  final List<bool> busesToAdd = List<bool>.filled(20, false);

  _BusesFormState(this.stopCode, this.updateStopCallback);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getStopBuses();
  }

  void getStopBuses() async {
    final List<Bus> buses = await NetworkRouter.getBusesStoppingAt(stopCode);
    this.setState(() {
      this.buses = buses;
      busesToAdd.fillRange(0, buses.length, false);
    });
    final BusStopData currentConfig = StoreProvider.of<AppState>(context)
        .state
        .content['configuredBusStops'][stopCode];
    if (currentConfig == null) return;
    for (int i = 0; i < buses.length; i++) {
      if (currentConfig.configuredBuses.contains(buses[i].busCode)) {
        busesToAdd[i] = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    updateBusStop();
    return ListView(
        children: List.generate(buses.length, (i) {
      return CheckboxListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('[${buses[i].busCode}] ${buses[i].destination}',
              overflow: TextOverflow.fade, softWrap: false),
          value: busesToAdd[i],
          onChanged: (value) {
            setState(() {
              busesToAdd[i] = value;
            });
          });
    }));
  }

  void updateBusStop() {
    final BusStopData currentConfig = StoreProvider.of<AppState>(context)
        .state
        .content['configuredBusStops'][stopCode];
    final Set<String> newBuses = Set();
    for (int i = 0; i < buses.length; i++) {
      if (busesToAdd[i]) {
        newBuses.add(buses[i].busCode);
      }
    }
    updateStopCallback(
        this.stopCode,
        BusStopData(
            configuredBuses: newBuses,
            favorited: currentConfig == null ? true : currentConfig.favorited));
  }
}
