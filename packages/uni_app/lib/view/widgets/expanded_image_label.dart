import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (imagePath.toLowerCase().endsWith('.svg'))
          SvgPicture.asset(imagePath, width: 250)
        else
          Image.asset(imagePath, height: 300, width: 300),
        const SizedBox(height: 20),
        Text(label, style: labelTextStyle, textAlign: TextAlign.center),
        if (sublabel.isNotEmpty) const SizedBox(height: 10),
        Text(sublabel, style: sublabelTextStyle, textAlign: TextAlign.center),
      ],
    );
  }
}
