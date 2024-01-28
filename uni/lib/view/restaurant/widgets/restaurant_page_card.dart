import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/utils/favorite_widget_type.dart';
import 'package:uni/view/common_widgets/generic_card.dart';

class RestaurantPageCard extends GenericCard {
  RestaurantPageCard(this.restaurant, this.meals, {super.key})
      : super.customStyle(
          editingMode: false,
          onDelete: () {},
          hasSmallTitle: true,
          cardAction: CardFavoriteButton(restaurant),
        );
  final Restaurant restaurant;
  final Widget meals;

  @override
  Widget buildCardContent(BuildContext context) {
    return meals;
  }

  @override
  String getTitle(BuildContext context) {
    return restaurant.name;
  }

  @override
  void onClick(BuildContext context) {}

  @override
  void onRefresh(BuildContext context) {}
}

class CardFavoriteButton extends StatefulWidget {
  const CardFavoriteButton(this.restaurant, {super.key});

  final Restaurant restaurant;

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
    isFavorite = PreferencesController.getFavoriteRestaurants()
        .contains(widget.restaurant.name);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: isFavorite ? Icon(MdiIcons.heart) : Icon(MdiIcons.heartOutline),
      onPressed: () async {
        final favoriteRestaurants =
            PreferencesController.getFavoriteRestaurants();
        if (favoriteRestaurants.contains(widget.restaurant.name)) {
          favoriteRestaurants.remove(widget.restaurant.name);
        } else {
          favoriteRestaurants.add(widget.restaurant.name);
        }

        setState(() {
          PreferencesController.saveFavoriteRestaurants(
            favoriteRestaurants,
          );
          isFavorite = !isFavorite;
        });

        final favoriteCardTypes = PreferencesController.getFavoriteCards();
        if (context.mounted &&
            isFavorite &&
            !favoriteCardTypes.contains(FavoriteWidgetType.restaurant)) {
          showRestaurantCardHomeDialog(
            context,
            favoriteCardTypes,
            PreferencesController.saveFavoriteCards,
          );
        }
      },
    );
  }

  void showRestaurantCardHomeDialog(
    BuildContext context,
    List<FavoriteWidgetType> favoriteCardTypes,
    void Function(List<FavoriteWidgetType>) updateHomePage,
  ) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).restaurant_main_page),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(S.of(context).no),
          ),
          ElevatedButton(
            onPressed: () {
              updateHomePage(
                favoriteCardTypes + [FavoriteWidgetType.restaurant],
              );
              Navigator.of(context).pop();
            },
            child: Text(S.of(context).yes),
          ),
        ],
      ),
    );
  }
}
