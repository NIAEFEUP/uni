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

class HomePageViewState extends GeneralPageViewState {
  bool isBannerViewed = true;

  @override
  void initState() {
    super.initState();
    checkBannerViewed();
  }

  Future<void> checkBannerViewed() async {
    final pref = await AppSharedPreferences.isDataCollectionBannerViewed();
    setState(() {
      isBannerViewed = pref;
    });
  }

  Future<void> setBannerViewed() async {
    await AppSharedPreferences.setDataCollectionBannerViewed(isViewed: true);
    await checkBannerViewed();
  }

  @override
  Widget getBody(BuildContext context) {
    return isBannerViewed
        ? const MainCardsList()
        : Column(
            children: [
              BannerWidget(setBannerViewed),
              const Expanded(
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
