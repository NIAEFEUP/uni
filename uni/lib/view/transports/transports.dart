import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/common_widgets/generic_card.dart';
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
  String? getTitle() =>
      S.of(context).nav_title(NavigationItem.navTransports.route);

  @override
  Widget getBody(BuildContext context) {
    return ListView(
      children: transportsCards,
    );
  }

  @override
  Future<void> onRefresh(BuildContext context) async {
    for (final card in transportsCards) {
      card.onRefresh(context);
    }
  }
}
