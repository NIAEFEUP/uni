import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:uni_ui/cards/generic_card.dart';

class RestaurantCard extends StatelessWidget {
  const RestaurantCard({
    super.key,
    required this.restaurantName,
    required this.restaurantType,
    required this.menuItems,
    required this.isFavorite,
    this.onFavoriteToggle,
  });

  final String restaurantName;
  final String restaurantType;
  final List<MenuItem> menuItems;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    return GenericCard(
        key: key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RestaurantCardHeader(
                restaurantName: restaurantName,
                restaurantType: restaurantType,
                isFavorite: isFavorite,
                onFavoriteToggle: onFavoriteToggle),
            Column(
              children: menuItems
                  .map((menuItem) => RestaurantCardMenuItem(
                      menuItemName: menuItem.name, menuItemType: menuItem.type))
                  .toList(),
            ),
          ],
        ));
  }
}

class RestaurantCardHeader extends StatefulWidget {
  const RestaurantCardHeader({
    super.key,
    required this.restaurantName,
    required this.restaurantType,
    required this.isFavorite,
    this.onFavoriteToggle,
  });

  final String restaurantName;
  final String restaurantType;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;

  @override
  _RestaurantCardHeaderState createState() => _RestaurantCardHeaderState();
}

class _RestaurantCardHeaderState extends State<RestaurantCardHeader> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.5),
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: RestaurantIcons.getRestaurantIcon(
                  context, widget.restaurantType)),
          Expanded(
            flex: 4,
            child: Text(
              widget.restaurantName,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
                onPressed: () {
                  setState(() {
                    isFavorite = !isFavorite;
                  });
                  if (widget.onFavoriteToggle != null) {
                    widget.onFavoriteToggle!();
                  }
                },
                icon: isFavorite
                    ? UniIcon(PhosphorIconsFill.heart,
                        color: Theme.of(context).primaryColor)
                    : UniIcon(PhosphorIconsRegular.heart,
                        color: Theme.of(context).primaryColor)),
          ),
        ],
      ),
    );
  }
}

class RestaurantCardMenuItem extends StatelessWidget {
  const RestaurantCardMenuItem(
      {super.key, required this.menuItemName, required this.menuItemType});

  final String menuItemName;
  final String menuItemType;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              flex: 1,
              child: MenuItemIcons.getMenuItemIcon(context, menuItemType)),
          Expanded(
            flex: 5,
            child: Text(
              menuItemName,
              style: Theme.of(context).textTheme.bodyLarge,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}

class RestaurantIcons {
  static const cantina = PhosphorIconsDuotone.cookingPot;
  static const grill = PhosphorIconsDuotone.cookingPot;
  static const restaurant = PhosphorIconsDuotone.chefHat;
  static const snackBar = PhosphorIconsDuotone.hamburger;

  static UniIcon getRestaurantIcon(
      BuildContext context, String restaurantType) {
    var iconType;
    switch (restaurantType) {
      case "cantina":
        iconType = cantina;
        break;
      case "grill":
        iconType = grill;
        break;
      case "restaurant":
        iconType = restaurant;
        break;
      case "snackBar":
        iconType = snackBar;
        break;
      default:
        iconType = restaurant;
    }
    return UniIcon(iconType, color: Theme.of(context).primaryColor);
  }
}

class MenuItemIcons {
  static const cow = PhosphorIconsDuotone.cow;
  static const fish = PhosphorIconsDuotone.fish;
  static const vegetarian = PhosphorIconsDuotone.plant;
  static const soup = PhosphorIconsDuotone.bowlSteam;

  static UniIcon getMenuItemIcon(BuildContext context, String menuItemType) {
    var iconType;
    switch (menuItemType) {
      case "cow":
        iconType = cow;
        break;
      case "fish":
        iconType = fish;
        break;
      case "vegetarian":
        iconType = vegetarian;
        break;
      case "soup":
        iconType = soup;
        break;
      default:
        iconType = cow;
    }
    return UniIcon(iconType, color: Theme.of(context).primaryColor);
  }
}

class UniIcon extends PhosphorIcon {
  const UniIcon(
    IconData icon, {
    super.key,
    double size = 24,
    Color? color,
    String? semanticLabel,
    TextDirection? textDirection,
  }) : super(
          icon,
          size: size,
          color: color,
          semanticLabel: semanticLabel,
          textDirection: textDirection,
        );
}

class MenuItem {
  final String name;
  final String type;

  MenuItem({required this.name, required this.type});
}
