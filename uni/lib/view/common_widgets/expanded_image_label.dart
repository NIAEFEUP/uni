import 'package:flutter/material.dart';

class ImageLabel extends StatelessWidget {
  const ImageLabel({
    required this.imagePath,
    required this.label,
    super.key,
    this.labelTextStyle,
    this.sublabel = '',
    this.sublabelTextStyle,
  });
  final String imagePath;
  final String label;
  final TextStyle? labelTextStyle;
  final String sublabel;
  final TextStyle? sublabelTextStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Image.asset(
          imagePath,
          height: 300,
          width: 300,
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
