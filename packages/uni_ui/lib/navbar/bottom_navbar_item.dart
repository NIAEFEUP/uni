import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class BottomNavbarItem {
  BottomNavbarItem({
    required this.icon,
  });

  final IconData icon;

  BottomNavigationBarItem toBottomNavigationBarItem(
    BuildContext context,
    bool selected,
  ) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: EdgeInsets.all(6),
        decoration: selected ? BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary.withAlpha(0x2f),
          borderRadius: BorderRadius.circular(10),
        ) : null,
        child: PhosphorIcon(
          icon,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      label: '',
    );
  }
}