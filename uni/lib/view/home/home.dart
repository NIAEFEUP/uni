import 'package:flutter/material.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/utils/favorite_widget_type.dart';
import 'package:provider/provider.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/providers/lazy/home_page_provider.dart';
import 'package:uni/view/common_widgets/page_title.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/widgets/profile_button.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/widgets/top_navigation_bar.dart';
import 'package:uni/view/home/widgets/main_cards_list.dart';
import 'package:uni/view/home/widgets/tracking_banner.dart';
import 'package:uni/view/home/widgets/uni_icon.dart';

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

  @override
  String? getTitle() => null;

  @override
  AppTopNavbar? getTopNavbar(BuildContext context) {
    return const AppTopNavbar(
      leftButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: UniIcon(),
      ),
      rightButton: ProfileButton(),
    );
  }
}
