import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/library_occupation.dart';
import 'package:uni/utils/drawer_items.dart';
import 'package:uni/view/common_widgets/page_title.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';
import 'package:uni/view/library/widgets/library_occupation_tab.dart';

import 'package:uni/view/library/widgets/library_reservations_tab.dart';

class LibraryPageView extends StatefulWidget {
  const LibraryPageView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LibraryPageViewState();
}

class LibraryPageViewState extends GeneralPageViewState<LibraryPageView> {
  @override
  Widget getBody(BuildContext context) {
    return StoreConnector<AppState, Tuple2<LibraryOccupation?, RequestStatus>>(
        converter: (store) {
      final LibraryOccupation? occupation =
          store.state.content['libraryOccupation'];
      return Tuple2(occupation, store.state.content['libraryOccupationStatus']);
    }, builder: (context, occupationInfo) {
      if (occupationInfo.item2 == RequestStatus.busy) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return LibraryPage(occupationInfo.item1);
      }
    });
  }
}

class LibraryPage extends StatelessWidget {
  final LibraryOccupation? occupation;

  const LibraryPage(this.occupation, {super.key});

  static const List<Tab> tabs = <Tab>[
    Tab(text: 'Ocupação'),
    Tab(text: 'Gabinetes'),
  ];

  @override
  Widget build(BuildContext context) {
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
              child: TabBarView(controller: tabController, children: [
            LibraryOccupationTab(occupation),
            const LibraryReservationsTab()
          ]))
        ]);
      }),
    );
  }
}
