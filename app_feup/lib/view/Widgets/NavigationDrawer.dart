import 'package:app_feup/view/Theme.dart';
import 'package:flutter/material.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:app_feup/model/AppState.dart';

class NavigationDrawer extends StatefulWidget {

  final VoidCallback callbackAction;

  const NavigationDrawer({Key key, this.callbackAction}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new NavigationDrawerState();
  }
}

class NavigationDrawerState extends State<NavigationDrawer> {

  static final drawerItems = [
    "Área Pessoal",
    "Horário",
    "Mapa de Exames",
    "About",
  ];

  _onSelectItem(int index) {

    var prev = StoreProvider.of<AppState>(context).state.content["selected_page"];

    Navigator.of(context).pop();

    if (prev != drawerItems[index])  // If not already in selected page
      Navigator.pushReplacementNamed(context, '/' + drawerItems[index]);

    // Trigger action example
    if(widget.callbackAction != null) widget.callbackAction();
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

  Widget createLogoutBtn() {
    return new RaisedButton(
      onPressed: () => print('log out'),
      textColor: Colors.white,
      color: primaryColor,
      elevation: 10,
      highlightElevation: 0,
      padding: const EdgeInsets.all(0.0),
      child: Container(
        padding: const EdgeInsets.all(15.0),
        child: Text('Log out', style: Theme.of(context).textTheme.display1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerOptions = [];

    for (var i = 0; i < drawerItems.length; i++) {
      drawerOptions.add(createDrawerNavigationOption(drawerItems[i], i));
    }

    return new Drawer(
        child: new Padding (
            padding: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0, bottom: 20.0 ),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: new ListView(
                    children: drawerOptions,
                  ),
                ),
                Row(
                    children: <Widget> [
                      Expanded(
                          child: createLogoutBtn()
                      )
                    ]
                )
              ],
            )
        )
    );
  }
}