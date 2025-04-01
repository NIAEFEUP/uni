import 'package:flutter/material.dart';
import 'package:uni/view/common_widgets/expanded_image_label.dart';
import 'package:uni/view/common_widgets/icon_label.dart';
import 'package:uni_ui/icons.dart';

import '../../../../generated/l10n.dart';

class NoClassesHomeCard extends StatelessWidget {
  const NoClassesHomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return IconLabel(
        icon: const UniIcon(UniIcons.beer),
        label: S.of(context).no_class,
        labelTextStyle: TextStyle(
          fontSize: 17,
          color: Theme.of(context).colorScheme.primary,
        ),
    );

    /*
    return ImageLabel(
      /* just a scratch */
      imagePath: 'assets/images/school.png',
      label: S.of(context).no_class,
      labelTextStyle: TextStyle(
        fontSize: 17,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
     */
  }
}
