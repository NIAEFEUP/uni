import 'package:flutter/material.dart';
import 'package:uni/utils/drawer_items.dart';
import 'package:uni/view/common_widgets/page_title.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';
import 'package:uni/view/library/widgets/library_occupation_tab.dart';

import 'package:uni/view/library/widgets/library_reservations_tab.dart';

class LibraryPage extends StatefulWidget {
  final bool startOnOccupationTab;
  const LibraryPage({this.startOnOccupationTab = true, Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => LibraryPageViewState();
}

class LibraryPageViewState extends GeneralPageViewState<LibraryPage> {
  late final List<Tab> tabs;

  LibraryPageViewState() {
    tabs = const <Tab>[
      Tab(text: 'Ocupação'),
      Tab(text: 'Gabinetes'),
    ];
  }

  @override
  Widget getBody(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Builder(builder: (BuildContext context) {
        final TabController? tabController = DefaultTabController.of(context);
        if (!widget.startOnOccupationTab) {
          tabController!.index = 1;
        }
        return Column(children: <Widget>[
          ListView(
            scrollDirection: Axis.vertical,
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
              child: TabBarView(controller: tabController, children: const [
            LibraryOccupationTab(),
            LibraryReservationsTab()
          ]))
        ]);
      }),
    );
  }
}
