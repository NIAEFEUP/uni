import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/app_locale.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/utils/favorite_widget_type.dart';
import 'package:uni/view/common_widgets/generic_card.dart';
import 'package:uni/view/locale_notifier.dart';

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
    final locale = Provider.of<LocaleNotifier>(context).getLocale();
    final restaurantName =
        locale == AppLocale.pt ? restaurant.namePt : restaurant.nameEn;
    switch (restaurant.period) {
      case 'lunch':
        return '$restaurantName - ${S.of(context).lunch}';
      case 'dinner':
        return '$restaurantName - ${S.of(context).dinner}';
      case 'breakfast':
        return '$restaurantName - ${S.of(context).breakfast}';
      case 'snackbar':
        return '$restaurantName - ${S.of(context).snackbar}';
      default:
        return restaurantName;
    }
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
        .contains(widget.restaurant.namePt + widget.restaurant.period);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: isFavorite ? Icon(MdiIcons.heart) : Icon(MdiIcons.heartOutline),
      onPressed: () async {
        final favoriteRestaurants =
            PreferencesController.getFavoriteRestaurants();
        if (favoriteRestaurants
            .contains(widget.restaurant.namePt + widget.restaurant.period)) {
          favoriteRestaurants
              .remove(widget.restaurant.namePt + widget.restaurant.period);
        } else {
          favoriteRestaurants
              .add(widget.restaurant.namePt + widget.restaurant.period);
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
