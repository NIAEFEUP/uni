import 'package:flutter/material.dart';
import 'package:uni/view/widgets/expanded_image_label.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    super.key,
    required this.imagePath,
    required this.title,
    this.subtitle,
    this.titleStyle,
    this.subtitleStyle,
  });

  final String imagePath;
  final String title;
  final String? subtitle;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  @override
  Widget build(BuildContext context) {
    return ImageLabel(
      imagePath: imagePath,
      label: title,
      labelTextStyle: titleStyle ?? Theme.of(context).textTheme.headlineLarge,
      sublabel: subtitle ?? '',
      sublabelTextStyle: subtitleStyle ?? Theme.of(context).textTheme.bodyLarge,
    );
  }
}
