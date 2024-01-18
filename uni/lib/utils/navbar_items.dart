import 'package:flutter/material.dart';

enum NavbarItem {
  navPersonalArea(
    Icons.home_outlined,
    ['area', ''],
  ),
  navAcademicPath(
    Icons.school_outlined,
    ['horario', 'exames', 'cadeiras'],
  ),
  navTransports(
    Icons.directions_bus_filled_outlined,
    ['autocarros']
  ),
  navFaculty(
    Icons.domain_outlined,
    ['locais', 'biblioteca', 'uteis'],
  ),
  navRestaurants(
    Icons.local_cafe_outlined,
    ['restaurantes'],
  );

  const NavbarItem(this.icon, this.routes);

  final IconData icon;
  final List<String> routes;
  // TODO(Process-ing): Transform into single route when the new pages are done

  BottomNavigationBarItem toBottomNavigationBarItem() {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: '',
    );
  }
}
