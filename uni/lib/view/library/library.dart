import 'package:flutter/material.dart';
import 'package:uni/utils/drawer_items.dart';
import 'package:uni/view/common_widgets/page_title.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';
import 'package:uni/view/library/widgets/library_occupation_tab.dart';

import 'package:uni/view/library/widgets/library_reservations_tab.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LibraryPageViewState();
}

class LibraryPageViewState extends GeneralPageViewState<LibraryPage> {
  @override
  Widget getBody(BuildContext context) {
    const List<Tab> tabs = <Tab>[
      Tab(text: 'Ocupação'),
      Tab(text: 'Gabinetes'),
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Builder(builder: (BuildContext context) {
        final TabController? tabController = DefaultTabController.of(context);
        tabController!.index = 0;
        return Column(children: <Widget>[
          ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: <Widget>[
              PageTitle(name: DrawerItem.navLibrary.title),
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
