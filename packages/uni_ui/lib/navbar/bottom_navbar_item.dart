import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

abstract class NavbarDefaultIcons {
  static final home = PhosphorIcons.house(PhosphorIconsStyle.duotone);
  static final academic =
      PhosphorIcons.graduationCap(PhosphorIconsStyle.duotone);
  static final restaurant = PhosphorIcons.forkKnife(PhosphorIconsStyle.duotone);
  static final faculty = PhosphorIcons.buildings(PhosphorIconsStyle.duotone);
  static final map = PhosphorIcons.mapTrifold(PhosphorIconsStyle.duotone);
}

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
        decoration: isSelected()
            ? BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary.withAlpha(0x2f),
                borderRadius: BorderRadius.circular(10),
              )
            : null,
        child: PhosphorIcon(
          icon,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      label: '',
    );
  }
}
