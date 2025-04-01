import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart';

class NoRestaurantsHomeCard extends StatelessWidget {
  const NoRestaurantsHomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            S.of(context).no_favorite_restaurants,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
          onPressed: () {
            //Navigator.pushNamed(context, '/restaurantPage');
          },
          child: Text(
            S.of(context).add_restaurants,
            style: TextStyle(
              fontSize: 17,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
