import 'package:app_feup/controller/networking/NetworkRouter.dart';
import 'package:app_feup/model/entities/Bus.dart';
import 'package:app_feup/model/entities/BusStop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BusesForm extends StatefulWidget {
  final String stopToAdd;
  final Function updateStopCallback;

  BusesForm(this.stopToAdd, this.updateStopCallback);

  @override
  State<StatefulWidget> createState() {return _BusesFormState(stopToAdd, updateStopCallback);}
}

class _BusesFormState extends State<BusesForm>{
  final String stopToAdd;
  final Function updateStopCallback;
  List<Bus> buses = new List();
  final List<bool> busesToAdd = List<bool>.filled(20, false);

  _BusesFormState(this.stopToAdd, this.updateStopCallback);

  @override
  void initState() {
    getStopBuses();
    super.initState();
  }

  void getStopBuses() async {
    List<Bus> buses = await NetworkRouter.getBusesStoppingAt(stopToAdd);
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
              Flexible(
                child: Text('[${buses[i].busCode}] ${buses[i].destination}', overflow: TextOverflow.fade, softWrap: false)
              ),
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
    updateStopCallback(new BusStop(stopCode: stopToAdd, buses: newBuses, favorited: true));
  }
}