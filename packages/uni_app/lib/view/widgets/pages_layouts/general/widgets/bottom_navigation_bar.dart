import 'package:flutter/material.dart';
import 'package:uni/utils/navbar_items.dart';
import 'package:uni_ui/navbar/bottom_navbar.dart';
import 'package:uni_ui/navbar/bottom_navbar_item.dart';

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
    final newRoute = NavbarItem.values[index].route;

    if (_getCurrentRoute(context) != newRoute) {
      Navigator.pushNamed(
        context,
        '/$newRoute',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentIndex(context);
    final navbarItems = <BottomNavbarItem>[];
    for (var index = 0; index < NavbarItem.values.length; index++) {
      final item = NavbarItem.values[index];
      navbarItems.insert(
        index,
        BottomNavbarItem(
          icon: item.icon,
          isSelected: () => currentIndex == index,
          onTap: () => _onItemTapped(context, index),
        ),
      );
    }

    return BottomNavbar(
      items: navbarItems,
    );
  }
}
