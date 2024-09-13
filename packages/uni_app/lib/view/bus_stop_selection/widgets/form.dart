import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/controller/fetchers/departures_fetcher.dart';
import 'package:uni/model/entities/bus.dart';
import 'package:uni/model/entities/bus_stop.dart';
import 'package:uni/model/providers/lazy/bus_stop_provider.dart';

class BusesForm extends StatefulWidget {
  const BusesForm(this.stopCode, this.updateStopCallback, {super.key});

  final String stopCode;
  final void Function(String, BusStopData) updateStopCallback;

  @override
  State<StatefulWidget> createState() {
    return BusesFormState();
  }
}

class BusesFormState extends State<BusesForm> {
  List<Bus> buses = [];
  final List<bool> busesToAdd = List<bool>.filled(20, false);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getStopBuses();
  }

  Future<void> getStopBuses() async {
    final buses = await DeparturesFetcher.getBusesStoppingAt(widget.stopCode);
    setState(() {
      this.buses = buses;
      busesToAdd.fillRange(0, buses.length, false);
    });
    if (!mounted) {
      return;
    }
    final currentConfig = Provider.of<BusStopProvider>(context, listen: false)
        .state![widget.stopCode];
    if (currentConfig == null) {
      return;
    }
    for (var i = 0; i < buses.length; i++) {
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
          contentPadding: EdgeInsets.zero,
          title: Text(
            '[${buses[i].busCode}] ${buses[i].destination}',
            overflow: TextOverflow.fade,
            softWrap: false,
          ),
          value: busesToAdd[i],
          onChanged: (value) {
            setState(() {
              busesToAdd[i] = value!;
            });
          },
        );
      }),
    );
  }

  void updateBusStop() {
    final currentConfig = Provider.of<BusStopProvider>(context, listen: false)
        .state![widget.stopCode];
    final newBuses = <String>{};
    for (var i = 0; i < buses.length; i++) {
      if (busesToAdd[i]) {
        newBuses.add(buses[i].busCode);
      }
    }
    widget.updateStopCallback(
      widget.stopCode,
      BusStopData(
        configuredBuses: newBuses,
        favorited: currentConfig == null || currentConfig.favorited,
      ),
    );
  }
}
