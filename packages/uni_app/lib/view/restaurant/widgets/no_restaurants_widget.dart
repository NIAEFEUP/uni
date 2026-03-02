import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/view/widgets/expanded_image_label.dart';

class NoRestaurantsWidget extends StatelessWidget {
  const NoRestaurantsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ImageLabel(
      imagePath: 'assets/images/chef.png',
      label: S.of(context).no_restaurants_available,
      labelTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: Theme.of(context).colorScheme.primary,
      ),
      sublabel: S.of(context).no_restaurants_available_sublabel,
      sublabelTextStyle: Theme.of(context).textTheme.bodyLarge,
    );
  }
}
