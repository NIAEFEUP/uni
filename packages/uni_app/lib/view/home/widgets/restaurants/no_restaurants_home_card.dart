import 'package:flutter/material.dart';
import 'package:uni/view/common_widgets/expanded_image_label.dart';

import '../../../../generated/l10n.dart';

class NoRestaurantsHomeCard extends StatelessWidget {
  const NoRestaurantsHomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ImageLabel(
        /* just a scratch */
        imagePath: 'assets/images/school.png',
        label: S.of(context).no_favorite_restaurants,
        labelTextStyle: TextStyle(
        fontSize: 17,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
