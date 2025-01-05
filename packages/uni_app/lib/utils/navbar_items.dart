import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni_ui/icons.dart';

enum NavbarItem {
  // TODO(thePeras): Remove duplication
  navPersonalArea(
    UniIcons.home,
    UniIcons.home,
    NavigationItem.navPersonalArea,
  ),
  navAcademicPath(
    UniIcons.graduationCap,
    UniIcons.graduationCap,
    NavigationItem.navAcademicPath,
  ),
  navRestaurants(
    UniIcons.restaurant,
    UniIcons.restaurant,
    NavigationItem.navRestaurants,
  ),
  navFaculty(
    UniIcons.faculty,
    UniIcons.faculty,
    NavigationItem.navFaculty,
  ),
  // TODO(thePeras): Change Transports to Map
  navTransports(
    UniIcons.map,
    UniIcons.map,
    NavigationItem.navTransports,
  );

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
