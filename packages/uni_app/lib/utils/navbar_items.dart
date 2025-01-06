import 'package:flutter/material.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni_ui/icons.dart';

enum NavbarItem {
  navPersonalArea(
    UniIcons.home,
    NavigationItem.navPersonalArea,
  ),
  navAcademicPath(
    UniIcons.graduationCap,
    NavigationItem.navAcademicPath,
  ),
  navRestaurants(
    UniIcons.restaurant,
    NavigationItem.navRestaurants,
  ),
  navFaculty(
    UniIcons.faculty,
    NavigationItem.navFaculty,
  ),
  navMap(
    UniIcons.map,
    NavigationItem.navMap,
  );

  const NavbarItem(this.icon, this.item);

  final IconData icon;
  final NavigationItem item;

  String get route {
    return item.route;
  }
}
