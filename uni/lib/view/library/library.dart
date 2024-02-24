import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/common_widgets/page_title.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';
import 'package:uni/view/common_widgets/pages_layouts/secondary/secondary.dart';
import 'package:uni/view/library/widgets/library_occupation_tab.dart';
import 'package:uni/view/library/widgets/library_reservations_tab.dart';

enum LibraryPageTab {
  occupation,
  reservations,
}

class LibraryPage extends StatefulWidget {
  const LibraryPage({this.startTab = LibraryPageTab.occupation, super.key});
  final LibraryPageTab startTab;

  @override
  State<StatefulWidget> createState() => LibraryPageState();
}

class LibraryPageState extends SecondaryPageViewState<LibraryPage> {
  late TabController tabController;
  late List<Tab> tabs;
  static const List<Widget> tabsContent = [
    LibraryOccupationTab(),
    LibraryReservationsTab(),
  ];

  @override
  Future<void> onRefresh(BuildContext context) {
    if (tabController.index == 0) {
      return (tabsContent[0] as LibraryOccupationTab).refresh(context);
    } else {
      return (tabsContent[1] as LibraryReservationsTab).refresh(context);
    }
  }

  @override
  Widget getBody(BuildContext context) {
    tabs = <Tab>[
      Tab(text: S.of(context).library_tab_occupation),
      Tab(text: S.of(context).library_tab_reservations),
    ];
    return DefaultTabController(
      length: tabs.length,
      child: Builder(
        builder: (BuildContext builderContext) {
          tabController = DefaultTabController.of(builderContext);
          tabController.index =
              (widget.startTab == LibraryPageTab.occupation) ? 0 : 1;
          return Column(
            children: <Widget>[
              TabBar(
                controller: tabController,
                physics: const BouncingScrollPhysics(),
                tabs: tabs,
              ),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: tabsContent,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  String? getTitle() =>
      S.of(context).nav_title(NavigationItem.navLibrary.route);
}
