import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:uni_ui/cards/restaurant_card.dart';
import 'package:uni_ui/cards/widgets/restaurant_menu_item.dart';

class ShimmerRestaurantsHomeCard extends StatelessWidget {
  const ShimmerRestaurantsHomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      effect: ShimmerEffect(
        baseColor: Theme.of(context).colorScheme.onSecondaryFixed,
        highlightColor: Theme.of(context).colorScheme.onSecondary,
        duration: const Duration(seconds: 3),
      ),
      child: ExpandablePageView.builder(
        controller: PageController(viewportFraction: 0.9),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: RestaurantCard(
              name: BoneMock.name,
              icon: const Icon(Icons.restaurant),
              isFavorite: false,
              onFavoriteToggle: () {},
              showFavoriteButton: false,
              menuItems: List.generate(
                2,
                (idx) => RestaurantMenuItem(
                  name: BoneMock.title,
                  icon: const Icon(Icons.restaurant_menu),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
