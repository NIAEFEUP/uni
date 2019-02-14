import 'package:app_feup/view/Theme.dart';
import 'package:flutter/material.dart';

class NavigationDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new NavigationDrawerState();
  }
}

class NavigationDrawerState extends State<NavigationDrawer> {
  int _selectedIndex = 0;

  final drawerItems = [
    "Área Pessoal",
    "Horário",
    "Classificações",
    "Ementa",
    "Mapa de Exames",
    "Parques",
    "Mapa FEUP",
  ];

  _getDrawerItemScreen(int pos) {
    //TODO
  }

  _onSelectItem(int index) {
    setState(() {
      _selectedIndex = index;
      _getDrawerItemScreen(_selectedIndex);
    });
    Navigator.of(context).pop(); // close the drawer
//    Navigator.push(
//      context,
//      new MaterialPageRoute(
//        builder: (context) => _getDrawerItemScreen(_selectedIndex),
//      ),
//    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerOptions = [];
    for (var i = 0; i < drawerItems.length; i++) {
      var d = drawerItems[i];
      drawerOptions.add(new ListTile(
        title: new Text(d, style: applicationTheme.textTheme.body1),
        selected: i == _selectedIndex,
        onTap: () => _onSelectItem(i),
      ));
    }

    return new Drawer(
        child: new ListView(
          children: drawerOptions,
        ),
    );
  }
}