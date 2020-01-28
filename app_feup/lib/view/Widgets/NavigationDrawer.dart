import 'package:app_feup/view/Theme.dart';
import 'package:flutter/material.dart';


class NavigationDrawer extends StatefulWidget {
  final BuildContext parentContext;

  NavigationDrawer({
    @required this.parentContext
  }){}
  @override
  State<StatefulWidget> createState() {
    return new NavigationDrawerState(parentContext: parentContext);
  }
}

class NavigationDrawerState extends State<NavigationDrawer> {
  final BuildContext parentContext;

  NavigationDrawerState({
    @required this.parentContext
  }){}

  static final drawerItems = [
    "Área Pessoal",
    "Horário",
    "Mapa de Exames",
    "Paragens",
    "Sobre",
    "Bug Report"
  ];

  getCurrentRoute() => ModalRoute.of(parentContext).settings.name == null ? drawerItems[0] : ModalRoute.of(parentContext).settings.name.substring(1);

  _onSelectItem(int index) {

    final prev = getCurrentRoute();

    Navigator.of(context).pop();

    if (prev != drawerItems[index]){
      Navigator.pushNamed(context, '/' + drawerItems[index]);
    }
  }

  _buildBorder(name) {
    return (name == getCurrentRoute()) ? (const BoxDecoration( border: Border( bottom: BorderSide(width: 5.0, color: primaryColor)))) : null;
  }

  Widget createLogOutOption() {
    return new ListTile(
      title: new Row(
        children: <Widget>[
          new Container(
            decoration: _buildBorder("Terminar sessão"),
            child: new Text("Terminar sessão",
                style: TextStyle(fontSize: 24.0, color: primaryColor)),
          ),
        ],
      ),
      onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/Terminar sessão', (_) => false),
    );
  }

  Widget createDrawerNavigationOption(String d, int i) {
    return new ListTile(
      title: new Row(
        children: <Widget>[
          new Container(
            decoration: _buildBorder(d),
            child: new Text(d,
                style: TextStyle(fontSize: 24.0, color: primaryColor)),
          ),
        ],
      ),
      selected: d == getCurrentRoute(),
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
        child: new Padding(
      padding: EdgeInsets.all(20.0),
      child: new Column(
        children: <Widget>[
          Flexible(
            child: new ListView(
              children: drawerOptions,
            ),
          ),
          Container(
            child: createLogOutOption(),
          ),
        ],
      ),
    ));
  }
}
