import 'package:flutter/widgets.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni_ui/theme.dart';

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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Text(
            S.of(context).add_restaurants,
            style: TextStyle(
              fontSize: 17,
              color: Theme.of(context).primaryVibrant,
            ),
          ),
        ),
      ],
    );
  }
}
