import 'package:flutter/material.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/utils/favorite_widget_type.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';
import 'package:uni/view/home/widgets/main_cards_list.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<StatefulWidget> createState() => HomePageViewState();
}

/// Tracks the state of Home page.
class HomePageViewState extends GeneralPageViewState {
  List<FavoriteWidgetType> favoriteCardTypes =
      PreferencesController.getFavoriteCards();

  void setFavoriteCards(List<FavoriteWidgetType> favorites) {
    setState(() {
      favoriteCardTypes = favorites;
    });
    PreferencesController.saveFavoriteCards(favorites);
  }

  @override
  Widget getBody(BuildContext context) {
    return MainCardsList(favoriteCardTypes, setFavoriteCards);
  }

  @override
  Future<void> onRefresh(BuildContext context) async {
    final cards = favoriteCardTypes
        .map(
          (e) =>
              MainCardsList.cardCreators[e]!(const Key(''), editingMode: false),
        )
        .toList();

    for (final card in cards) {
      card.onRefresh(context);
    }
  }
}
