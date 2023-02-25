import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/providers/session_provider.dart';
import 'package:uni/utils/drawer_items.dart';
import 'package:uni/view/theme_notifier.dart';

class AppNavigationDrawer extends StatefulWidget {
  final BuildContext parentContext;

  const AppNavigationDrawer({super.key, required this.parentContext});

  @override
  State<StatefulWidget> createState() {
    return AppNavigationDrawerState();
  }
}

class AppNavigationDrawerState extends State<AppNavigationDrawer> {
  AppNavigationDrawerState();
  Map<DrawerItem, Function(String)> drawerItems = {};

  @override
  void initState() {
    super.initState();

    drawerItems = {};
    for (var element in DrawerItem.values) {
      drawerItems[element] = _onSelectPage;
    }
  }

  // Callback Functions
  getCurrentRoute() =>
      ModalRoute.of(widget.parentContext)!.settings.name == null
          ? drawerItems.keys.toList()[0].title
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
    final String logOutText = DrawerItem.navLogOut.title;
    return TextButton(
      onPressed: () => _onLogOut(logOutText),
      style: TextButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(15.0),
        child: Text(logOutText,
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Theme.of(context).primaryColor)),
      ),
    );
  }

  Widget createThemeSwitchBtn() {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
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

  Widget createDrawerNavigationOption(DrawerItem d) {
    return Container(
        decoration: _getSelectionDecoration(d.title),
        child: ListTile(
          title: Container(
            padding: const EdgeInsets.only(bottom: 3.0, left: 20.0),
            child: Text(d.title,
                style: TextStyle(
                    fontSize: 18.0,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.normal)),
          ),
          dense: true,
          contentPadding: const EdgeInsets.all(0.0),
          selected: d.title == getCurrentRoute(),
          onTap: () => drawerItems[d]!(d.title),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> drawerOptions = [];
    final userSession = Provider.of<SessionProvider>(context).session;

    for (var key in drawerItems.keys) {
      if (key.isVisible(userSession.faculties)) {
        drawerOptions.add(createDrawerNavigationOption(key));
      }
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
