import 'package:flutter/widgets.dart';
import 'package:uni_ui/icons.dart';
import 'package:uni_ui/theme.dart';

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
        decoration:
            isSelected()
                ? BoxDecoration(
                  color: Theme.of(context).details.withAlpha(0x2f),
                  borderRadius: BorderRadius.circular(10),
                )
                : null,
        child: UniIcon(icon, size: 32, color: Theme.of(context).secondary),
      ),
      label: '',
    );
  }
}
