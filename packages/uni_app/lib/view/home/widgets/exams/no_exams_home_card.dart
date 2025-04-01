import 'package:flutter/material.dart';
import 'package:uni/view/common_widgets/expanded_image_label.dart';
import 'package:uni/view/common_widgets/icon_label.dart';
import 'package:uni_ui/icons.dart';

import '../../../../generated/l10n.dart';

class NoExamsHomeCard extends StatelessWidget {
  const NoExamsHomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return IconLabel(
        icon: const UniIcon(UniIcons.island),
        label: S.of(context).no_exams,
        labelTextStyle: TextStyle(
          fontSize: 17,
          color: Theme.of(context).colorScheme.primary,
        ),
    );


    /*
    return ImageLabel(
      imagePath: 'assets/images/school.png',
      label: S.of(context).no_exams,
      labelTextStyle: TextStyle(
        fontSize: 17,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
     */
  }
}
