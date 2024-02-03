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
  navRestaurants(
    Icons.local_cafe_outlined,
    ['restaurantes'],
  ),
  navFaculty(
    Icons.domain_outlined,
    ['locais', 'biblioteca', 'uteis', 'calendario'],
  ),
  navTransports(Icons.map_outlined, ['autocarros']);

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
