import 'package:app_feup/view/Theme.dart';
import 'package:flutter/material.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:app_feup/redux/actionCreators.dart';
import 'package:app_feup/model/AppState.dart';

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

  _onSelectItem(int index) {

    StoreProvider.of<AppState>(context).dispatch(updateSelectedPage(drawerItems[index]));

    Navigator.of(context).pop(); // close the drawer
//    Navigator.push(
//      context,
//      new MaterialPageRoute(
//        builder: (context) => _getDrawerItemScreen(_selectedIndex),
//      ),
//    );
  }

  _buildBorder(name) {
    return (name == StoreProvider.of<AppState>(context).state.content["selected_page"])?  (const BoxDecoration( border: Border( bottom: BorderSide(width: 5.0, color: primaryColor)))) : null;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerOptions = [];
    for (var i = 0; i < drawerItems.length; i++) {
      var d = drawerItems[i];

      drawerOptions.add(new ListTile(
        title:
            new Row(
              children: <Widget>[
                new Container(
                  decoration: _buildBorder(d),
                  child: new Text(d, style: TextStyle(fontSize: 24.0, color: primaryColor)),
                ),
              ],
            ),
        selected: d == StoreProvider.of<AppState>(context).state.content["selected_page"],
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