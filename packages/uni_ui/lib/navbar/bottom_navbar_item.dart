import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class BottomNavbarItem {
  BottomNavbarItem({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final bool Function() isSelected;
  final void Function() onTap;

  BottomNavigationBarItem toBottomNavigationBarItem(BuildContext context) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: EdgeInsets.all(6),
        decoration: isSelected() ? BoxDecoration(
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