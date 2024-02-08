import 'package:flutter/material.dart';

enum NavbarItem {
  navPersonalArea(Icons.home_outlined, 'area'),
  navAcademicPath(
    Icons.school_outlined,
    'percurso_academico',
  ),
  navRestaurants(
    Icons.local_cafe_outlined,
    'restaurantes',
  ),
  navFaculty(
    Icons.domain_outlined,
    'faculdade',
  ),
  navTransports(
    Icons.map_outlined,
    'transportes',
  );

  const NavbarItem(this.icon, this.route);

  final IconData icon;
  final String route;

  BottomNavigationBarItem toBottomNavigationBarItem() {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: '',
    );
  }
}
