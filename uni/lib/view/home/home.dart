import 'package:flutter/material.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/utils/favorite_widget_type.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';
import 'package:uni/view/home/widgets/main_cards_list.dart';
import 'package:uni/view/home/widgets/tracking_banner.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<StatefulWidget> createState() => HomePageViewState();
}

class HomePageViewState extends GeneralPageViewState {
  bool isBannerViewed = true;
  bool isEditing = false;
  List<FavoriteWidgetType> favoriteCardTypes =
      PreferencesController.getFavoriteCards();

  @override
  void initState() {
    super.initState();
    checkBannerViewed();
  }

  Future<void> checkBannerViewed() async {
    setState(() {
      isBannerViewed = PreferencesController.isDataCollectionBannerViewed();
    });
  }

  Future<void> setBannerViewed() async {
    await PreferencesController.setDataCollectionBannerViewed(isViewed: true);
    await checkBannerViewed();
  }

  void setFavoriteCards(List<FavoriteWidgetType> favorites) {
    setState(() {
      favoriteCardTypes = favorites;
    });
    PreferencesController.saveFavoriteCards(favorites);
  }

  void toggleEditing() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  @override
  Widget getBody(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: !isBannerViewed,
          child: TrackingBanner(setBannerViewed),
        ),
        Expanded(
          child: MainCardsList(
            favoriteCardTypes,
            saveFavoriteCards: setFavoriteCards,
            isEditing: isEditing,
            toggleEditing: toggleEditing,
          ),
        ),
      ],
    );
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
