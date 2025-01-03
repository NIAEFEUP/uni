import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:uni_ui/cards/generic_card.dart';
import 'package:uni_ui/cards/widgets/restaurant_menu_item.dart';

class RestaurantCard extends StatelessWidget {
  const RestaurantCard({
    super.key,
    required this.name,
    required this.icon,
    required this.menuItems,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  final String name;
  final Icon icon;
  final List<RestaurantMenuItem> menuItems;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    return GenericCard(
        key: key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RestaurantCardHeader(
                name: name,
                icon: icon,
                isFavorite: isFavorite,
                onFavoriteToggle: onFavoriteToggle),
            Column(
              children: menuItems),
          ],
        ));
  }
}

class RestaurantCardHeader extends StatelessWidget {
  const RestaurantCardHeader({
    super.key,
    required this.name,
    required this.icon,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  final String name;
  final Icon icon;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 9),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: icon),
          Expanded(
            flex: 4,
            child: Text(
              name,
              style: Theme.of(context).textTheme.headlineSmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
                onPressed: onFavoriteToggle,
                icon: isFavorite
                    ? Icon(PhosphorIconsFill.heart,
                    color: Theme.of(context).primaryColor)
                    : Icon(PhosphorIconsRegular.heart,
                    color: Theme.of(context).primaryColor)),
          ),
        ],
      ),
    );
  }
}