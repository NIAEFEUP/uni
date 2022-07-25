import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/constants.dart' as constants;
import '../../../theme_notifier.dart';

class NavigationDrawer extends StatefulWidget {
  final BuildContext parentContext;

  const NavigationDrawer({super.key, required this.parentContext});

  @override
  State<StatefulWidget> createState() {
    return NavigationDrawerState();
  }
}

class NavigationDrawerState extends State<NavigationDrawer> {
  NavigationDrawerState();
  Map drawerItems = {};

  @override
  void initState() {
    super.initState();

    drawerItems = {
      constants.navPersonalArea: _onSelectPage,
      constants.navSchedule: _onSelectPage,
      constants.navExams: _onSelectPage,
      constants.navStops: _onSelectPage,
      constants.navUsefulLinks: _onSelectPage,
      constants.navUsefulContacts: _onSelectPage,
      constants.navAbout: _onSelectPage,
      constants.navBugReport: _onSelectPage,
    };
  }

  // Callback Functions
  getCurrentRoute() =>
      ModalRoute.of(widget.parentContext)!.settings.name == null
          ? drawerItems.keys.toList()[0]
          : ModalRoute.of(widget.parentContext)!.settings.name!.substring(1);

  _onSelectPage(String key) {
    final prev = getCurrentRoute();

    Navigator.of(context).pop();

    if (prev != key) {
      Navigator.pushNamed(context, '/$key');
    }
  }

  _onLogOut(String key) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/$key', (Route<dynamic> route) => false);
  }

  // End of Callback Functions

  BoxDecoration? _getSelectionDecoration(String name) {
    return (name == getCurrentRoute())
        ? BoxDecoration(
            border: Border(
                left: BorderSide(
                    color: Theme.of(context).primaryColor, width: 3.0)),
            color: Theme.of(context).dividerColor,
          )
        : null;
  }

  Widget createLogoutBtn() {
    return TextButton(
      onPressed: () => _onLogOut(constants.navLogOut),
      style: TextButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(15.0),
        child: Text(constants.navLogOut,
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Theme.of(context).primaryColor)),
      ),
    );
  }

  Widget createThemeSwitchBtn() {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    Icon getThemeIcon() {
      switch (themeNotifier.getTheme()) {
        case ThemeMode.light:
          return const Icon(Icons.wb_sunny);
        case ThemeMode.dark:
          return const Icon(Icons.nightlight_round);
        default:
          return const Icon(Icons.brightness_6);
      }
    }

    return IconButton(
        icon: getThemeIcon(), onPressed: themeNotifier.setNextTheme);
  }

  Widget createDrawerNavigationOption(String d) {
    return Container(
        decoration: _getSelectionDecoration(d),
        child: ListTile(
          title: Container(
            padding: const EdgeInsets.only(bottom: 3.0, left: 20.0),
            child: Text(d,
                style: TextStyle(
                    fontSize: 18.0,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.normal)),
          ),
          dense: true,
          contentPadding: const EdgeInsets.all(0.0),
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
          padding: const EdgeInsets.only(top: 55.0),
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
