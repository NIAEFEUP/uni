import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/view/common_widgets/expanded_image_label.dart';

class EmptyWeek extends StatelessWidget {
  const EmptyWeek({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      heightFactor: 1.2,
      child: ImageLabel(
        imagePath: 'assets/images/schedule.png',
        label: S.of(context).no_class,
        labelTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Theme.of(context).colorScheme.primary,
        ),
        sublabel: S.of(context).no_classes_this_week,
        sublabelTextStyle: const TextStyle(fontSize: 15),
      ),
    );
  }
}
