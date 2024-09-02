import 'package:flutter/material.dart';
import 'package:uni_ui/generic_card.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class MenuItem {
  final String name;
  final String type;

  MenuItem({required this.name, required this.type});
}

class RestaurantCard extends StatefulWidget {
  final String title;
  final String establishmentType;
  final List<MenuItem> menuItems;

  const RestaurantCard({
    super.key,
    required this.title,
    required this.establishmentType,
    required this.menuItems,
  });

  @override
  _RestaurantCardState createState() => _RestaurantCardState();
}

class _RestaurantCardState extends State<RestaurantCard> {
  bool isFavorite = false;

  void _toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  IconData? _getIconForMenuItemType(String type) {
    switch (type.toLowerCase()) {
      case 'meat':
        return PhosphorIconsBold.cow;
      case 'fish':
        return PhosphorIconsBold.fish;
      default:
        return PhosphorIconsBold.leaf;
    }
  }

  Color _getIconColorForMenuItemType(String type) {
    return Theme.of(context).colorScheme.primary;
  }

  @override
  Widget build(BuildContext context) {
    Widget establishmentIcon;
    switch (widget.establishmentType.toLowerCase()) {
      case 'cafeteria':
      case 'snack-bar':
        establishmentIcon = Icon(PhosphorIconsBold.hamburger, color: Theme.of(context).colorScheme.primary, size: 32.0);
        break;
      case 'cantina':
      case 'grill':
        establishmentIcon = Icon(PhosphorIconsBold.cookingPot, color: Theme.of(context).colorScheme.primary, size: 32.0);
        break;
      case 'restaurant':
      default:
        establishmentIcon = Icon(PhosphorIconsBold.chefHat, color: Theme.of(context).colorScheme.primary, size: 32.0);
        break;
    }

    return GenericCard(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: 16.0,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              establishmentIcon,
              const SizedBox(width: 8),
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: _toggleFavorite,
                child: Icon(
                  isFavorite
                      ? PhosphorIconsFill.heartStraight
                      : PhosphorIconsRegular.heartStraight,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Divider(
            color: Theme.of(context).dividerColor,
            thickness: 1.0,
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.menuItems.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Icon(
                      _getIconForMenuItemType(item.type),
                      color: _getIconColorForMenuItemType(item.type),
                      size: 24.0,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item.name,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}