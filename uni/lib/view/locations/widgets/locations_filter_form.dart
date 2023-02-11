import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/redux/action_creators.dart';

class LocationsFilterForm extends StatefulWidget {
  final Map<String, bool> filteredLocations;

  const LocationsFilterForm(this.filteredLocations, {super.key});
  @override
  LocationsFilterFormState createState() => LocationsFilterFormState();
}

class LocationsFilterFormState extends State<LocationsFilterForm> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Definições Filtro de Locais',
          style: Theme.of(context).textTheme.headline5),
      actions: [
        TextButton(
            child:
                Text('Cancelar', style: Theme.of(context).textTheme.bodyText2),
            onPressed: () => Navigator.pop(context)),
        ElevatedButton(
            child: const Text('Confirmar'),
            onPressed: () {
              StoreProvider.of<AppState>(context).dispatch(
                  setFilteredLocations(widget.filteredLocations, Completer()));

              Navigator.pop(context);
            })
      ],
      content: SizedBox(
          height: 300.0,
          width: 200.0,
          child: getLocationsCheckboxes(widget.filteredLocations, context)),
    );
  }

  Widget getLocationsCheckboxes(
      Map<String, bool> filteredLocations, BuildContext context) {
    return ListView(
        children: List.generate(filteredLocations.length, (i) {
      final String key = filteredLocations.keys.elementAt(i);

      return CheckboxListTile(
          contentPadding: const EdgeInsets.all(0),
          title: Text(
            key,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            maxLines: 2,
          ),
          key: Key('LocationCheck$key'),
          value: filteredLocations[key],
          onChanged: (value) {
            setState(() {
              filteredLocations[key] = value!;
            });
          });
    }));
  }
}
