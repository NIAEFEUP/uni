import 'package:app_feup/view/Theme.dart';
import 'package:flutter/material.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:app_feup/model/AppState.dart';

class NavigationDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new NavigationDrawerState();
  }
}

class NavigationDrawerState extends State<NavigationDrawer> {

  static final drawerItems = [
    "Área Pessoal",
    "Horário",
    "Classificações",
    "Ementa",
    "Mapa de Exames",
    "Parques",
    "Mapa FEUP",
    "About",
    "Bug Report"
  ];

  _onSelectItem(int index) {

    var prev = StoreProvider.of<AppState>(context).state.content["selected_page"];

    Navigator.of(context).pop();

    if (prev != drawerItems[index])  // If not already in selected page
      Navigator.pushNamed(context, '/' + drawerItems[index]);
  }

  _buildBorder(name) {
    return (name == StoreProvider.of<AppState>(context).state.content["selected_page"])?  (const BoxDecoration( border: Border( bottom: BorderSide(width: 5.0, color: primaryColor)))) : null;
  }

  Widget createDrawerNavigationOption(String d, int i) {
    return new ListTile(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerOptions = [];

    for (var i = 0; i < drawerItems.length; i++) {
      drawerOptions.add(createDrawerNavigationOption(drawerItems[i], i));
    }

    return new Drawer(
        child: new Container(
            padding: EdgeInsets.all(20.0),
              child: new ListView(
                children: drawerOptions,
          ),
        )
    );
  }
}