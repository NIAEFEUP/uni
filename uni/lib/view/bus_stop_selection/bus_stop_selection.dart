import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/controller/local_storage/app_bus_stop_database.dart';
import 'package:uni/model/entities/bus_stop.dart';
import 'package:uni/model/providers/bus_stop_provider.dart';
import 'package:uni/view/bus_stop_selection/widgets/bus_stop_search.dart';
import 'package:uni/view/bus_stop_selection/widgets/bus_stop_selection_row.dart';
import 'package:uni/view/common_widgets/page_title.dart';
import 'package:uni/view/common_widgets/pages_layouts/secondary/secondary.dart';

class BusStopSelectionPage extends StatefulWidget {
  const BusStopSelectionPage({super.key});

  @override
  State<StatefulWidget> createState() => BusStopSelectionPageState();
}

/// Manages the 'Bus stops' section of the app.
class BusStopSelectionPageState
    extends SecondaryPageViewState<BusStopSelectionPage> {
  final double borderRadius = 15.0;
  final DateTime now = DateTime.now();

  final db = AppBusStopDatabase();
  final Map<String, BusStopData> configuredStops = {};
  final List<String> suggestionsList = [];

  List<Widget> getStopsTextList() {
    final List<Widget> stops = [];
    configuredStops.forEach((stopCode, stopData) {
      stops.add(Text(stopCode));
    });
    return stops;
  }

  @override
  Widget getBody(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Consumer<BusStopProvider>(builder: (context, busProvider, _) {
      final List<Widget> rows = [];
      busProvider.configuredBusStops.forEach((stopCode, stopData) =>
          rows.add(BusStopSelectionRow(stopCode, stopData)));
      return ListView(
          padding: const EdgeInsets.only(
            bottom: 20,
          ),
          children: <Widget>[
            const PageTitle(name: 'Autocarros Configurados'),
            Container(
                padding: const EdgeInsets.all(20.0),
                child: const Text(
                    '''Os autocarros favoritos serão apresentados no widget 'Autocarros' dos favoritos.'''
                    '''Os restantes serão apresentados apenas na página.''',
                    textAlign: TextAlign.center)),
            Column(children: rows),
            Container(
                padding:
                    EdgeInsets.only(left: width * 0.20, right: width * 0.20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () => showSearch(
                            context: context, delegate: BusStopSearch()),
                        child: const Text('Adicionar'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Concluído'),
                      ),
                    ]))
          ]);
    });
  }
}
