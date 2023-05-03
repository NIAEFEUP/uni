import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/providers/faculty_locations_provider.dart';

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
      title: Text('Filtro de Locais',
          style: Theme.of(context).textTheme.headlineSmall),
      actions: [
        TextButton(
            child:
                Text('Cancelar', style: Theme.of(context).textTheme.bodyMedium),
            onPressed: () => Navigator.pop(context)),
        ElevatedButton(
            child: const Text('Confirmar'),
            onPressed: () {
              Provider.of<FacultyLocationsProvider>(context, listen: false)
                  .setFilteredLocations(widget.filteredLocations, Completer());

              Navigator.pop(context);
            })
      ],
      content: SizedBox(
          height: 300.0,
          width: 200.0,
          child: getLocationsCheckboxes(widget.filteredLocations, context)),
    );
  }

  String stringTypeToReadableString(String loc) {
    switch (loc) {
      case 'COFFEE_MACHINE':
        return 'Máquinas de Café';
      case 'VENDING_MACHINE':
        return 'Máquinas de Venda';
      case 'ROOM':
        return 'Salas';
      case 'ROOMS':
        return 'Agregado de Salas';
      case 'SPECIAL_ROOM':
        return 'Salas Especiais';
      case 'ATM':
        return 'Atms';
      case 'PRINTER':
        return 'Impressoras';
      case 'RESTAURANT':
        return 'Restaurante';
      case 'STORE':
        return 'Loja';
      case 'WC':
        return 'Wc';
      default:
        return 'Outros';
    }
  }

  Widget getLocationsCheckboxes(
      Map<String, bool> filteredLocations, BuildContext context) {
    return ListView(
        children: List.generate(filteredLocations.length, (i) {
      final String key = filteredLocations.keys.elementAt(i);

      return CheckboxListTile(
          contentPadding: const EdgeInsets.all(0),
          title: Text(
            stringTypeToReadableString(key),
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
