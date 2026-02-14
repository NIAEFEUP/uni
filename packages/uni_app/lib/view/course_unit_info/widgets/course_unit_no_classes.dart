import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/view/widgets/expanded_image_label.dart';

class NoClassWidget extends StatelessWidget {
  const NoClassWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ImageLabel(
      imagePath: 'assets/images/classes.png',
      label: S.of(context).no_class,
      labelTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: Theme.of(context).colorScheme.primary,
      ),
      sublabel: S.of(context).no_course_unit_classes,
      sublabelTextStyle: const TextStyle(fontSize: 15),
    );
  }
}
