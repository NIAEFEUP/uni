import 'package:app_feup/view/Theme.dart';
import 'package:flutter/material.dart';
import '../../utils/Constants.dart' as Constants;

class NavigationDrawer extends StatefulWidget {
  final BuildContext parentContext;

  NavigationDrawer({@required this.parentContext}) {}

  @override
  State<StatefulWidget> createState() {
    return new NavigationDrawerState(parentContext: parentContext);
  }
}

class NavigationDrawerState extends State<NavigationDrawer> {
  final BuildContext parentContext;

  NavigationDrawerState({@required this.parentContext}) {}

  Map drawerItems = {};

  @override
  void initState() {
    super.initState();

    drawerItems = {
      Constants.NAV_PERSONAL_AREA: _onSelectPage,
      Constants.NAV_SCHEDULE: _onSelectPage,
      Constants.NAV_EXAMS: _onSelectPage,
      Constants.NAV_ABOUT: _onSelectPage,
      Constants.NAV_BUG_REPORT: _onSelectPage,
    };
  }

  // Callback Functions
  getCurrentRoute() => ModalRoute.of(parentContext).settings.name == null
      ? drawerItems.keys.toList()[0]
      : ModalRoute.of(parentContext).settings.name.substring(1);

  _onSelectPage(String key) {
    final prev = getCurrentRoute();

    Navigator.of(context).pop();

    if (prev != key) {
      Navigator.pushNamed(context, '/' + key);
    }
  }

  _onLogOut(String key) {
    Navigator.pushReplacementNamed(context, '/' + key);
  }

  // End of Callback Functions

  _buildBorder(name) {
    return (name == getCurrentRoute())
        ? (const BoxDecoration(
            border:
                Border(bottom: BorderSide(width: 5.0, color: primaryColor))))
        : null;
  }

  Widget createLogoutBtn() {
    return OutlineButton(
      onPressed: () => _onLogOut(Constants.NAV_LOG_OUT),
      highlightElevation: 0,
      padding: const EdgeInsets.all(0.0),
      child: Container(
        padding: const EdgeInsets.all(15.0),
        child: Text(Constants.NAV_LOG_OUT, style: Theme.of(context).textTheme.title.apply(color: primaryColor)),
      ),
    );
  }

  Widget createDrawerNavigationOption(String d) {
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
      onTap: () => drawerItems[d](d),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerOptions = [];

    for (var key in drawerItems.keys) {
      drawerOptions.add(createDrawerNavigationOption(key));
    }

    return new Drawer(
        child: new Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: new ListView(
                    children: drawerOptions,
                  ),
                ),
                Row(children: <Widget>[Expanded(child: createLogoutBtn())])
              ],
            )));
  }
}
