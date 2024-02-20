import 'package:flutter/material.dart';
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
    Icons.local_cafe_outlined,
    Icons.local_cafe,
    NavigationItem.navRestaurants,
  ),
  navFaculty(Icons.domain_outlined, Icons.domain, NavigationItem.navFaculty),
  navTransports(Icons.map_outlined, Icons.map, NavigationItem.navTransports);

  const NavbarItem(this.unselectedIcon, this.selectedIcon, this.item);

  final IconData unselectedIcon;
  final IconData selectedIcon;
  final NavigationItem item;

  BottomNavigationBarItem toUnselectedBottomNavigationBarItem() {
    return BottomNavigationBarItem(
      icon: Icon(unselectedIcon),
      label: '',
    );
  }

  BottomNavigationBarItem toSelectedBottomNavigationBarItem() {
    return BottomNavigationBarItem(
      icon: Icon(selectedIcon),
      label: '',
    );
  }

  String get route {
    return item.route;
  }
}
