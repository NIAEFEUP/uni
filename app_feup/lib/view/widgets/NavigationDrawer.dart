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
  }

  _buildBorder(name) {
    return (name == StoreProvider.of<AppState>(context).state.content["selected_page"])?  (const BoxDecoration( border: Border( bottom: BorderSide(width: 5.0, color: primaryColor)))) : null;
  }

  Widget createSearchInputField()
  {
    return new ListTile(
        title:
        new Padding (
            padding: const EdgeInsets.only(bottom: 20.0,),
            child: new Row (
                children: <Widget> [
                  new Flexible (
                    child: new TextField (
                        decoration: new InputDecoration(
                            hintText: "Pesquisa..."
                        ),
                    ),
                  ),
                ]
            )
        )
    );
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

    drawerOptions.add(createSearchInputField());

    for (var i = 0; i < drawerItems.length; i++) {
      drawerOptions.add(createDrawerNavigationOption(drawerItems[i], i));
    }

    return new Drawer(
        child: new Padding (
          padding: EdgeInsets.all(20.0),
          child: new ListView(
            children: drawerOptions,
          ),
        )
    );
  }
}