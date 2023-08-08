import 'package:flutter/material.dart';
import 'package:uni/utils/navbar_items.dart';

class AppBottomNavbar extends StatefulWidget {
  const AppBottomNavbar({ required this.parentContext, super.key });

  final BuildContext parentContext;

  @override
  State<StatefulWidget> createState() {
    return AppBottomNavbarState();
  }
}

class AppBottomNavbarState extends State<AppBottomNavbar> {
  AppBottomNavbarState();

  static final List<BottomNavigationBarItem> navbarItems = NavbarItem.values
      .map((item) => item.toBottomNavigationBarItem())
      .toList();

  String _getCurrentRoute() =>
      ModalRoute.of(widget.parentContext)!.settings.name == null
          ? NavbarItem.values.toList()[0].label
          : ModalRoute.of(widget.parentContext)!.settings.name!.substring(1);

  int _getCurrentIndex() {
    final currentRoute = _getCurrentRoute();

    for (final item in NavbarItem.values) {
      if (item.routes.contains(currentRoute)) {
        return item.index;
      }
    }

    return NavbarItem.navPersonalArea.index;
  }

  void _onItemTapped(int index) {
    final prev = _getCurrentRoute();
    final item = NavbarItem.values[index];
    final key = item.routes.isNotEmpty
        ? item.routes[0]
        : NavbarItem.navPersonalArea.routes[0];

    if (prev != key) {
      Navigator.of(context).pop();
      Navigator.pushNamed(context, '/$key');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: navbarItems,
      currentIndex: _getCurrentIndex(),
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Theme.of(context).colorScheme.onSurface,
      onTap: _onItemTapped,
    );
  }
}
