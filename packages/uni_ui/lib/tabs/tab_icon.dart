import 'package:flutter/material.dart';
import 'package:uni_ui/icons.dart';

class TabIcon extends StatelessWidget {
  const TabIcon({
    super.key,
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          UniIcon(icon),
          const SizedBox(width: 4),
          Text(text),
        ],
      ),
    );
  }
}
