import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/providers/lazy/home_page_provider.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';
import 'package:uni/view/home/widgets/main_cards_list.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<StatefulWidget> createState() => HomePageViewState();
}

/// Tracks the state of Home page.
class HomePageViewState extends GeneralPageViewState {
  @override
  Widget getBody(BuildContext context) {
    return const MainCardsList();
  }

  @override
  Future<void> onRefresh(BuildContext context) async {
    final favoriteCardTypes = context.read<HomePageProvider>().favoriteCards;
    final cards = favoriteCardTypes
        .map((e) =>
            MainCardsList.cardCreators[e]!(const Key(''), false, () => null),)
        .toList();

    for (final card in cards) {
      card.onRefresh(context);
    }
  }
}
