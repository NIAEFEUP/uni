import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:uni/model/entities/library_occupation.dart';
import 'package:uni/model/providers/library_occupation_provider.dart';
import 'package:uni/view/common_widgets/page_title.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni/view/library/widgets/library_occupation_card.dart';

class LibraryPageView extends StatefulWidget {
  const LibraryPageView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LibraryPageViewState();
}

class LibraryPageViewState extends GeneralPageViewState<LibraryPageView> {
  @override
  Widget getBody(BuildContext context) {
    return LazyConsumer<LibraryOccupationProvider>(
        builder: (context, libraryOccupationProvider, _) =>
            LibraryPage(libraryOccupationProvider.occupation));

/*
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
     */
  }
}

class LibraryPage extends StatelessWidget {
  final LibraryOccupation? occupation;

  const LibraryPage(this.occupation, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: [
          const PageTitle(name: 'Biblioteca'),
          LibraryOccupationCard(),
          if (occupation != null) const PageTitle(name: 'Pisos'),
          if (occupation != null) getFloorRows(context, occupation!),
        ]);
  }

  Widget getFloorRows(BuildContext context, LibraryOccupation occupation) {
    final List<Widget> floors = [];
    for (int i = 1; i < occupation.floors.length; i += 2) {
      floors.add(createFloorRow(
          context, occupation.getFloor(i), occupation.getFloor(i + 1)));
    }
    return Column(
      children: floors,
    );
  }

  Widget createFloorRow(
      BuildContext context, FloorOccupation floor1, FloorOccupation floor2) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      createFloorCard(context, floor1),
      createFloorCard(context, floor2),
    ]);
  }

  Widget createFloorCard(BuildContext context, FloorOccupation floor) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 150.0,
      width: 150.0,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          color: Theme.of(context).cardColor,
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(0x1c, 0, 0, 0),
              blurRadius: 7.0,
              offset: Offset(0.0, 1.0),
            )
          ]),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Text('Piso ${floor.number}',
            style: Theme.of(context).textTheme.headlineSmall),
        Text('${floor.percentage}%',
            style: Theme.of(context).textTheme.titleLarge),
        Text('${floor.occupation}/${floor.capacity}',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Theme.of(context).colorScheme.background)),
        LinearPercentIndicator(
          lineHeight: 7.0,
          percent: floor.percentage / 100,
          progressColor: Theme.of(context).colorScheme.secondary,
          backgroundColor: Theme.of(context).dividerColor,
        )
      ]),
    );
  }
}
