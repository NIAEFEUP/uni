import 'package:flutter/material.dart';
import 'package:uni_ui/icons.dart';

class IconLabel extends StatelessWidget {
  const IconLabel({
    required this.icon,
    required this.label,
    super.key,
    this.labelTextStyle,
    this.sublabel = '',
    this.sublabelTextStyle,
  });
  final UniIcon icon;
  final String label;
  final TextStyle? labelTextStyle;
  final String sublabel;
  final TextStyle? sublabelTextStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          icon.icon, // Use icon.icon to get the IconData
          size: 20,
        ),
        Text(
          label,
          style: labelTextStyle,
        ),
        if (sublabel.isNotEmpty) const SizedBox(height: 10),
        Text(
          sublabel,
          style: sublabelTextStyle,
        ),
      ],
    );
  }
}