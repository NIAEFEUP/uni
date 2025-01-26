import 'package:flutter/material.dart';
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        backgroundColor:
            const Color.fromRGBO(255, 245, 243, 1), // Button background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50), // Rounded edges
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Favoritos',
            style: TextStyle(
                fontSize: 12, color: Color.fromRGBO(127, 127, 127, 1)),
          ),
          const SizedBox(width: 8), // Space between text and icon
          if (!isFavoriteOn)
            const UniIcon(
              UniIcons.heartOutline,
            )
          else
            const UniIcon(UniIcons.heartFill),
        ],
      ),
    );
  }
}
