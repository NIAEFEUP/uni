import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';
import 'package:uni/model/providers/lazy/home_page_provider.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';
import 'package:uni/view/home/widgets/main_cards_list.dart';
import 'package:uni/view/home/widgets/tracking_banner.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<StatefulWidget> createState() => HomePageViewState();
}

/// Tracks the state of Home page.
class HomePageViewState extends GeneralPageViewState {
  bool? isBannerViewed;

  @override
  void initState() {
    super.initState();
    checkBannerViewed();
  }

  Future<void> checkBannerViewed() async {
    isBannerViewed = await AppSharedPreferences.isDataCollectionBannerViewed();
    await AppSharedPreferences.setDataCollectionBannerViewed(isViewed: true);
    setState(() {});
  }

  @override
  Widget getBody(BuildContext context) {
    return (isBannerViewed ?? false)
        ? const MainCardsList()
        : const Column(
            children: [
              BannerWidget(),
              Expanded(
                // Add this
                child: MainCardsList(),
              ),
            ],
          );
  }

  @override
  Future<void> onRefresh(BuildContext context) async {
    final favoriteCardTypes = context.read<HomePageProvider>().favoriteCards;
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
