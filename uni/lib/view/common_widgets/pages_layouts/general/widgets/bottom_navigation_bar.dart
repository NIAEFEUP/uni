import 'package:flutter/material.dart';
import 'package:uni/utils/navbar_items.dart';

class AppBottomNavbar extends StatelessWidget {
  const AppBottomNavbar({super.key});

  String? _getCurrentRoute(BuildContext context) =>
      ModalRoute.of(context)!.settings.name?.substring(1);

  int _getCurrentIndex(BuildContext context) {
    final currentRoute = _getCurrentRoute(context);
    if (_getCurrentRoute(context) == null) {
      return -1;
    }

    for (final item in NavbarItem.values) {
      if (item.route == currentRoute) {
        return item.index;
      }
    }

    return -1;
  }

  void _onItemTapped(BuildContext context, int index) {
    final prev = _getCurrentRoute(context);
    final item = NavbarItem.values[index];
    final key = item.route;

    if (prev != key) {
      Navigator.pushNamed(
        context,
        '/$key',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentIndex(context);
    final navbarItems = <BottomNavigationBarItem>[];
    for (var index = 0; index < NavbarItem.values.length; index++) {
      final item = NavbarItem.values[index];
      navbarItems.insert(
        index,
        index == currentIndex
            ? item.toSelectedBottomNavigationBarItem(context)
            : item.toUnselectedBottomNavigationBarItem(context),
      );
    }

    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: BottomNavigationBar(
        items: navbarItems,
        onTap: (index) => _onItemTapped(context, index),
        currentIndex: currentIndex == -1 ? 0 : currentIndex,
        type: BottomNavigationBarType.fixed,
        iconSize: 32,
        selectedItemColor: currentIndex == -1
            ? Theme.of(context).colorScheme.onSurface
            : Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
