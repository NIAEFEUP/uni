import 'package:flutter/material.dart';
import 'package:uni/utils/drawer_items.dart';
import 'package:uni/view/common_widgets/page_title.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';
import 'package:uni/view/library/widgets/library_occupation_tab.dart';
import 'package:uni/view/library/widgets/library_reservations_tab.dart';

class LibraryPageView extends StatefulWidget {
  const LibraryPageView({this.startOnOccupationTab = true, super.key});
  final bool startOnOccupationTab;

  @override
  State<StatefulWidget> createState() => LibraryPageViewState();
}

class LibraryPageViewState extends GeneralPageViewState<LibraryPageView> {
  LibraryPageViewState() {
    tabs = const <Tab>[
      Tab(text: 'Ocupação'),
      Tab(text: 'Gabinetes'),
    ];
  }
  late TabController tabController;
  late final List<Tab> tabs;
  static const LibraryOccupationTab _libraryOccupationTab =
      LibraryOccupationTab();
  static const LibraryReservationsTab _libraryReservationTab =
      LibraryReservationsTab();

  @override
  Future<void> onRefresh(BuildContext context) {
    if (tabController.index == 0) {
      return _libraryOccupationTab.refresh(context);
    } else {
      return _libraryReservationTab.refresh(context);
    }
  }

  @override
  Widget getBody(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Builder(
        builder: (BuildContext context) {
          tabController = DefaultTabController.of(context);
          if (!widget.startOnOccupationTab) {
            tabController.index = 1;
          }
          return Column(
            children: <Widget>[
              ListView(
                shrinkWrap: true,
                children: <Widget>[
                  PageTitle(name: DrawerItem.navLibraryOccupation.title),
                  TabBar(
                    controller: tabController,
                    physics: const BouncingScrollPhysics(),
                    tabs: tabs,
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: const [
                    _libraryOccupationTab,
                    _libraryReservationTab,
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
