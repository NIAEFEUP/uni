import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class BottomNavbarItem {
  BottomNavbarItem({
    required this.icon,
  });

  final IconData icon;

  BottomNavigationBarItem toBottomNavigationBarItem(
    BuildContext context,
  ) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: EdgeInsets.all(6),
        child: PhosphorIcon(
          icon,
          color: Theme.of(context).colorScheme.secondary,
          size: 32,
        ),
      ),
      label: '',
    );
  }
}