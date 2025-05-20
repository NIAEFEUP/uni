import 'package:flutter/material.dart';
import 'package:uni_ui/cards/generic_card.dart';
import 'package:uni_ui/cards/widgets/restaurant_menu_item.dart';
import 'package:uni_ui/icons.dart';

class RestaurantCard extends StatelessWidget {
  const RestaurantCard({
    super.key,
    required this.name,
    required this.icon,
    required this.menuItems,
    required this.isFavorite,
    required this.onFavoriteToggle,
    this.showFavoriteButton = true,
    this.onClick,
  });

  final String name;
  final Icon icon;
  final List<RestaurantMenuItem> menuItems;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final bool showFavoriteButton;
  final Function()? onClick;

  @override
  Widget build(BuildContext context) {
    return GenericCard(
      padding: EdgeInsets.zero,
      key: key,
      tooltip: name,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RestaurantCardHeader(
            name: name,
            icon: icon,
            isFavorite: isFavorite,
            onFavoriteToggle: onFavoriteToggle,
            showFavoriteButton: showFavoriteButton,
          ),
          Column(children: menuItems),
        ],
      ),
      onClick: onClick,
    );
  }
}

class RestaurantCardHeader extends StatelessWidget {
  const RestaurantCardHeader(
      {super.key,
      required this.name,
      required this.icon,
      required this.isFavorite,
      required this.onFavoriteToggle,
      this.showFavoriteButton = true});

  final String name;
  final Icon icon;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final bool showFavoriteButton;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Expanded(flex: 1, child: icon),
          Expanded(
            flex: 4,
            child: Text(
              name,
              style: Theme.of(context).textTheme.headlineSmall,
              overflow: TextOverflow.clip,
            ),
          ),
          if (showFavoriteButton)
            Expanded(
              flex: 1,
              child: CardFavoriteButton(isFavorite, onFavoriteToggle),
            ),
          if (!showFavoriteButton) Expanded(child: SizedBox(width: 8)),
        ],
      ),
    );
  }
}

class CardFavoriteButton extends StatefulWidget {
  const CardFavoriteButton(this.isFavorite, this.onFavoriteToggle, {super.key});

  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  @override
  State<StatefulWidget> createState() {
    return CardFavoriteButtonState();
  }
}

class CardFavoriteButtonState extends State<CardFavoriteButton> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: UniIcon(isFavorite ? UniIcons.heartFill : UniIcons.heartOutline),
        onPressed: () {
          widget.onFavoriteToggle();
          setState(() {
            isFavorite = !isFavorite;
          });
        });
  }
}
