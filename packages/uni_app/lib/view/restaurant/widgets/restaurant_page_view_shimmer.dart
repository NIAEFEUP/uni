import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:uni_ui/cards/restaurant_card.dart';
import 'package:uni_ui/cards/widgets/restaurant_menu_item.dart';

class ShimmerRestaurantPageView extends StatelessWidget {
  const ShimmerRestaurantPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView.separated(
        itemCount: 4,
        itemBuilder: (context, index) {
          return RestaurantCard(
            name: BoneMock.name,
            icon: const Icon(Icons.restaurant), // Dummy icon for skeletonizer
            isFavorite: false,
            onFavoriteToggle: () {},
            menuItems: List.generate(
              3,
              (idx) => RestaurantMenuItem(
                name: BoneMock.title,
                icon: const Icon(Icons.restaurant_menu),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 10),
      ),
    );
  }
}
