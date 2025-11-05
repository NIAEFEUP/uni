import 'package:flutter/widgets.dart';

class IconLabel extends StatelessWidget {
  const IconLabel({
    required this.icon,
    required this.label,
    super.key,
    this.labelTextStyle,
    this.sublabel = '',
    this.sublabelTextStyle,
    this.iconSize = 25.0, // Default icon size
  });

  final Icon icon;
  final String label;
  final TextStyle? labelTextStyle;
  final String sublabel;
  final TextStyle? sublabelTextStyle;
  final double iconSize; // New icon size parameter

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        icon,
        const SizedBox(height: 8),
        Text(label, style: labelTextStyle),
        if (sublabel.isNotEmpty) const SizedBox(height: 10),
        Text(sublabel, style: sublabelTextStyle),
      ],
    );
  }
}
