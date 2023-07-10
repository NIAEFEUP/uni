import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/providers/lazy/bus_stop_provider.dart';
import 'package:uni/model/providers/lazy/exam_provider.dart';
import 'package:uni/model/providers/lazy/home_page_provider.dart';
import 'package:uni/model/providers/lazy/lecture_provider.dart';
import 'package:uni/model/providers/lazy/library_occupation_provider.dart';
import 'package:uni/model/providers/lazy/reference_provider.dart';
import 'package:uni/model/providers/startup/profile_provider.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
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
  @override
  Widget getBody(BuildContext context) {
    return MainCardsList();
  }

  @override
  Future<void> handleRefresh(BuildContext context) async {
    final homePageProvider =
        Provider.of<HomePageProvider>(context, listen: false);

    final providersToUpdate = <StateProviderNotifier>{};

    for (final cardType in homePageProvider.favoriteCards) {
      switch (cardType) {
        case FavoriteWidgetType.account:
          providersToUpdate
              .add(Provider.of<ProfileProvider>(context, listen: false));
          providersToUpdate
              .add(Provider.of<ReferenceProvider>(context, listen: false));
          break;
        case FavoriteWidgetType.exams:
          providersToUpdate
              .add(Provider.of<ExamProvider>(context, listen: false));
          break;
        case FavoriteWidgetType.schedule:
          providersToUpdate
              .add(Provider.of<LectureProvider>(context, listen: false));
          break;
        case FavoriteWidgetType.printBalance:
          providersToUpdate
              .add(Provider.of<ProfileProvider>(context, listen: false));
          break;
        case FavoriteWidgetType.libraryOccupation:
          providersToUpdate.add(
              Provider.of<LibraryOccupationProvider>(context, listen: false));
          break;
        case FavoriteWidgetType.busStops:
          providersToUpdate
              .add(Provider.of<BusStopProvider>(context, listen: false));
          break;
      }
    }

    Future.wait(providersToUpdate.map((e) => e.forceRefresh(context)));
  }
}
