import 'package:flutter/material.dart';
import 'package:uni/utils/navigation_items.dart';

enum NavbarItem {
  navPersonalArea(Icons.home_outlined, NavigationItem.navPersonalArea),
  navAcademicPath(Icons.school_outlined, NavigationItem.navAcademicPath),
  navRestaurants(Icons.local_cafe_outlined, NavigationItem.navRestaurants),
  navFaculty(Icons.domain_outlined, NavigationItem.navFaculty),
  navTransports(Icons.map_outlined, NavigationItem.navTransports);

  const NavbarItem(this.icon, this.item);

  final IconData icon;
  final NavigationItem item;

  BottomNavigationBarItem toBottomNavigationBarItem() {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: '',
    );
  }

  String get route {
    return item.route;
  }
}
