import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/utils/drawer_items.dart';
import 'package:uni/view/common_widgets/generic_card.dart';
import 'package:uni/view/common_widgets/page_title.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';
import 'package:uni/view/home/widgets/bus_stop_card.dart';
import 'package:uni/view/transports/widgets/map_snapshot_card.dart';

class TransportsPageView extends StatefulWidget {
  const TransportsPageView({super.key});

  @override
  State<StatefulWidget> createState() => TransportsPageViewState();
}

class TransportsPageViewState extends GeneralPageViewState {
  List<GenericCard> transportsCards = [
    MapCard(),
    BusStopCard(),
    // Add more cards if needed
  ];

  @override
  Widget getBody(BuildContext context) {
    return ListView(
      children: [
        PageTitle(
          name: S.of(context).nav_title(DrawerItem.navTransports.title),
        ),
        Column(
          children: transportsCards,
        ),
      ],
    );
  }

  @override
  Future<void> onRefresh(BuildContext context) async {
    for (final card in transportsCards) {
      card.onRefresh(context);
    }
  }
}
