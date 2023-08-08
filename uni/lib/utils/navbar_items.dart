import 'package:flutter/material.dart';

enum NavbarItem {
  navPersonalArea(
      'Área Pessoal',
      Icons.home_outlined,
      ['Área Pessoal'],
  ),
  navStudentArea(
      'Área do Estudante',
      Icons.school_outlined,
      ['Horário', 'Exames', 'Cadeiras', 'Calendário'],
  ),
  navMap(
      'Mapa e Transportes',
      Icons.map_outlined,
      ['Autocarros', 'Locais'],
  ),
  navUsefulInfo(
      'Úteis',
      Icons.domain_outlined,
      ['Restaurantes', 'Biblioteca', 'Úteis'],
  ),
  navCurrentAccount(
      'Conta Corrente',
      Icons.account_balance_wallet_outlined,
      [],
  );

  const NavbarItem(this.label, this.icon, this.routes);

  final String label;
  final IconData icon;
  final List<String> routes;
  // TODO(Process-ing): Transform into single route when the new pages are done

  BottomNavigationBarItem toBottomNavigationBarItem() {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: label,
    );
  }
}
