import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni_ui/icons.dart';

class FavoriteRestaurantsButton extends StatelessWidget {
  const FavoriteRestaurantsButton({
    super.key,
    required this.isFavoriteOn,
    required this.onToggle,
  });

  final bool isFavoriteOn;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onToggle,
      style: TextButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            S.of(context).favorite_filter,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(width: 8),
          UniIcon(
            isFavoriteOn ? UniIcons.heartFill : UniIcons.heartOutline,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ],
      ),
    );
  }
}
