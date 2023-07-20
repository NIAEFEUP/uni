import 'package:flutter/material.dart';

class ImageLabel extends StatelessWidget {
  final String imagePath;
  final String label;
  final TextStyle? labelTextStyle;
  final String sublabel;
  final TextStyle? sublabelTextStyle;

  const ImageLabel({Key? key, required this.imagePath, required this.label, this.labelTextStyle, this.sublabel = '', this.sublabelTextStyle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Image.asset(
          imagePath,
          height: 300,
          width: 300,
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: labelTextStyle,
        ),
        if(sublabel.isNotEmpty)
          const SizedBox(height: 20),
          Text(
            sublabel,
            style: sublabelTextStyle,
          ),
      ],
    );
  }
}