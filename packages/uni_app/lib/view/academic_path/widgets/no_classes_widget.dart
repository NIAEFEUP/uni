import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/view/widgets/expanded_image_label.dart';

class NoClassesWidget extends StatelessWidget {
  const NoClassesWidget({super.key, this.showSublabel = true});

  final bool showSublabel;

  @override
  Widget build(BuildContext context) {
    return ImageLabel(
      imagePath: 'assets/images/school.png',
      label: S.of(context).no_classes,
      labelTextStyle: Theme.of(context).textTheme.headlineLarge,
      sublabel: showSublabel ? S.of(context).no_classes_this_week : '',
      sublabelTextStyle: showSublabel
          ? Theme.of(context).textTheme.bodyLarge
          : null,
    );
  }
}
