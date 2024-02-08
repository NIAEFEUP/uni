import 'package:flutter/material.dart';
import 'package:uni/utils/navbar_items.dart';
import 'package:uni/utils/navigation_items.dart';

class AppBottomNavbar extends StatefulWidget {
  const AppBottomNavbar({required this.parentContext, super.key});

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

  String? _getCurrentRoute() =>
      ModalRoute.of(widget.parentContext)!.settings.name?.substring(1);

  int _getCurrentIndex() {
    final currentRoute = _getCurrentRoute();
    if (_getCurrentRoute() == null) {
      return -1;
    }

    for (final item in NavbarItem.values) {
      if (item.routes.contains(currentRoute)) {
        return item.index;
      }
    }

    return -1;
  }

  void _onItemTapped(int index) {
    final prev = _getCurrentRoute();
    final item = NavbarItem.values[index];
    final key = item.routes.isNotEmpty
        ? item.routes[0]
        : NavigationItem.navPersonalArea.route;

    if (prev != key) {
      if (prev == '') {
        Navigator.pushNamed(context, '/$key');
      } else {
        Navigator.pushReplacementNamed(context, '/$key');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentIndex();
    return BottomNavigationBar(
      items: navbarItems,
      onTap: _onItemTapped,
      currentIndex: currentIndex == -1 ? 0 : currentIndex,
      type: BottomNavigationBarType.fixed,
      iconSize: 32,
      selectedItemColor: currentIndex == -1
          ? Theme.of(context).colorScheme.onSurface
          : Theme.of(context).colorScheme.secondary,
      unselectedItemColor: Theme.of(context).colorScheme.onSurface,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    );
  }
}
