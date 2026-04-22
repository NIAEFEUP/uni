import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/view/widgets/expanded_image_label.dart';

class NoCoursesWidget extends StatelessWidget {
  const NoCoursesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ImageLabel(
      imagePath: 'assets/images/school.png',
      label: S.of(context).no_courses,
      labelTextStyle: Theme.of(context).textTheme.headlineLarge,
      sublabel: S.of(context).no_courses_description,
      sublabelTextStyle: Theme.of(context).textTheme.bodyLarge,
    );
  }
}
