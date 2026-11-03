import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';

class NoRestaurantsHomeCard extends StatelessWidget {
  const NoRestaurantsHomeCard({super.key, required this.onClick});

  final void Function(BuildContext) onClick;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(child: Text(S.of(context).no_favorite_restaurants)),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => onClick(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
          child: Text(
            S.of(context).add_restaurants,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
