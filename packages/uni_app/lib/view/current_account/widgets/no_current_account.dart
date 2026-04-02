import 'package:flutter/material.dart';
import 'package:uni/view/widgets/expanded_image_label.dart';

class CurrentAccountNoInfo extends StatelessWidget {
  const CurrentAccountNoInfo({
    super.key,
    required this.label,
    required this.sublabel,
  });

  final String label;
  final String sublabel;

  @override
  Widget build(BuildContext context) {
    return ImageLabel(
      imagePath: 'assets/images/current_account.png',
      label: label,
      labelTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: Theme.of(context).colorScheme.primary,
      ),
      sublabel: sublabel,
      sublabelTextStyle: Theme.of(context).textTheme.bodyLarge,
    );
  }
}
