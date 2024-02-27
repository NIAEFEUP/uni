import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/utils/navigation_items.dart';

enum NavbarItem {
  navPersonalArea(
    Icons.home_outlined,
    Icons.home,
    NavigationItem.navPersonalArea,
  ),
  navAcademicPath(
    Icons.school_outlined,
    Icons.school,
    NavigationItem.navAcademicPath,
  ),
  navRestaurants(
    Icons.free_breakfast_outlined,
    Icons.free_breakfast,
    NavigationItem.navRestaurants,
  ),
  navFaculty(Icons.domain_outlined, Icons.domain, NavigationItem.navFaculty),
  navTransports(Icons.map_outlined, Icons.map, NavigationItem.navTransports);

  const NavbarItem(this.unselectedIcon, this.selectedIcon, this.item);

  final IconData unselectedIcon;
  final IconData selectedIcon;
  final NavigationItem item;

  BottomNavigationBarItem toUnselectedBottomNavigationBarItem(
    BuildContext context,
  ) {
    return BottomNavigationBarItem(
      icon: Icon(unselectedIcon),
      label: '',
      tooltip: S.of(context).nav_title(item.route),
    );
  }

  BottomNavigationBarItem toSelectedBottomNavigationBarItem(
    BuildContext context,
  ) {
    return BottomNavigationBarItem(
      icon: Icon(selectedIcon),
      label: '',
      tooltip: S.of(context).nav_title(item.route),
    );
  }

  String get route {
    return item.route;
  }
}
