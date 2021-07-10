import 'package:flutter/material.dart';
import '../../utils/constants.dart' as Constants;
import '../theme_notifier.dart';
import 'package:provider/provider.dart';

class NavigationDrawer extends StatefulWidget {
  final BuildContext parentContext;

  NavigationDrawer({@required this.parentContext}) {}

  @override
  State<StatefulWidget> createState() {
    return NavigationDrawerState(parentContext: parentContext);
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
      Constants.navPersonalArea: _onSelectPage,
      Constants.navSchedule: _onSelectPage,
      Constants.navExams: _onSelectPage,
      Constants.navStops: _onSelectPage,
      Constants.navAbout: _onSelectPage,
      Constants.navBugReport: _onSelectPage,
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
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/' + key, (Route<dynamic> route) => false);
  }

  // End of Callback Functions

  Decoration _getSelectionDecoration(String name) {
    return (name == getCurrentRoute())
        ? BoxDecoration(
            border: Border(
                left: BorderSide(
                    color: Theme.of(context).accentColor, width: 3.0)),
            color: Theme.of(context).dividerColor,
          )
        : null;
  }

  Widget createLogoutBtn() {
    return TextButton(
      onPressed: () => _onLogOut(Constants.navLogOut),
      style: TextButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(15.0),
        child: Text(Constants.navLogOut,
            style: Theme.of(context)
                .textTheme
                .headline6
                .apply(color: Theme.of(context).accentColor)),
      ),
    );
  }

  Widget createThemeSwitchBtn() {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    Icon _getThemeIcon() {
      switch (themeNotifier.getTheme()) {
        case ThemeMode.light:
          return Icon(Icons.wb_sunny);
        case ThemeMode.dark:
          return Icon(Icons.nightlight_round);
        default:
          return Icon(Icons.brightness_6);
      }
    }

    return IconButton(
        icon: _getThemeIcon(), onPressed: themeNotifier.setNextTheme);
  }

  Widget createDrawerNavigationOption(String d) {
    return Container(
        decoration: _getSelectionDecoration(d),
        child: ListTile(
          title: Container(
            padding: EdgeInsets.only(bottom: 3.0, left: 20.0),
            child: Text(d,
                style: TextStyle(
                    fontSize: 18.0,
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.normal)),
          ),
          dense: true,
          contentPadding: EdgeInsets.all(0.0),
          selected: d == getCurrentRoute(),
          onTap: () => drawerItems[d](d),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> drawerOptions = [];

    for (var key in drawerItems.keys) {
      drawerOptions.add(createDrawerNavigationOption(key));
    }

    return Drawer(
        child: Column(
      children: <Widget>[
        Expanded(
            child: Container(
          padding: EdgeInsets.only(top: 55.0),
          child: ListView(
            children: drawerOptions,
          ),
        )),
        Row(children: <Widget>[
          Expanded(child: createLogoutBtn()),
          createThemeSwitchBtn()
        ])
      ],
    ));
  }
}
