import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/library_occupation.dart';
import 'package:uni/model/providers/lazy/library_occupation_provider.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/common_widgets/page_title.dart';
import 'package:uni/view/common_widgets/pages_layouts/secondary/secondary.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni/view/library/widgets/library_occupation_card.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<StatefulWidget> createState() => LibraryPageState();
}

class LibraryPageState extends SecondaryPageViewState<LibraryPage> {
  @override
  Widget getBody(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        LibraryOccupationCard(),
        PageTitle(name: S.of(context).floors),
        LazyConsumer<LibraryOccupationProvider, LibraryOccupation>(
          builder: getFloorRows,
          hasContent: (occupation) => occupation.floors.isNotEmpty,
          onNullContent: Center(
            child: Text(
              S.of(context).no_library_info,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          contentLoadingWidget: const CircularProgressIndicator(),
        ),
      ],
    );
  }

  // This will lazy consume
  Widget getFloorRows(BuildContext context, LibraryOccupation occupation) {
    final floors = <Widget>[];
    for (var i = 1; i < occupation.floors.length; i += 2) {
      floors.add(
        createFloorRow(
          context,
          occupation.getFloor(i),
          occupation.getFloor(i + 1),
        ),
      );
    }
    return Column(
      children: floors,
    );
  }

  Widget createFloorRow(
    BuildContext context,
    FloorOccupation floor1,
    FloorOccupation floor2,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        createFloorCard(context, floor1),
        createFloorCard(context, floor2),
      ],
    );
  }

  Widget createFloorCard(BuildContext context, FloorOccupation floor) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 150,
      width: 150,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: Theme.of(context).cardColor,
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(0x1c, 0, 0, 0),
            blurRadius: 7,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            '${S.of(context).floor} ${floor.number}',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
            '${floor.percentage}%',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            '${floor.occupation}/${floor.capacity}',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Theme.of(context).colorScheme.secondary),
          ),
          LinearPercentIndicator(
            lineHeight: 7,
            percent: floor.percentage / 100,
            progressColor: Theme.of(context).colorScheme.secondary,
            backgroundColor: Theme.of(context).dividerColor,
          ),
        ],
      ),
    );
  }

  @override
  Future<void> onRefresh(BuildContext context) {
    return Provider.of<LibraryOccupationProvider>(context, listen: false)
        .forceRefresh(context);
  }

  @override
  String? getTitle() =>
      S.of(context).nav_title(NavigationItem.navLibrary.route);
}
