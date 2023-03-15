import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/entities/library_occupation.dart';
import 'package:uni/model/providers/library_occupation_provider.dart';
import 'package:uni/model/request_status.dart';
import 'package:uni/view/common_widgets/page_title.dart';
import 'package:uni/view/library/widgets/library_occupation_card.dart';

class LibraryOccupationTab extends StatefulWidget {
  const LibraryOccupationTab({Key? key}) : super(key: key);

  @override
  LibraryOccupationTabState createState() => LibraryOccupationTabState();
}

class LibraryOccupationTabState extends State<LibraryOccupationTab> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LibraryOccupationProvider>(
        builder: (context, occupationProvider, _) {
      if (occupationProvider.status == RequestStatus.busy) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return LibraryOccupationTabView(occupationProvider.occupation);
      }
    });
  }
}

class LibraryOccupationTabView extends StatelessWidget {
  final LibraryOccupation? occupation;

  const LibraryOccupationTabView(this.occupation, {super.key});

  @override
  Widget build(BuildContext context) {
    if (occupation == null || occupation?.capacity == 0) {
      return ListView(scrollDirection: Axis.vertical, children: [
        Center(
            heightFactor: 2,
            child: Text('Não existem dados para apresentar',
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center))
      ]);
    }
    return ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: [
          LibraryOccupationCard(),
          if (occupation != null) const PageTitle(name: 'Pisos'),
          if (occupation != null) FloorRows(occupation!),
        ]);
  }
}

class FloorRows extends StatelessWidget {
  final LibraryOccupation occupation;

  const FloorRows(this.occupation, {super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> floors = [];
    for (int i = 1; i < occupation.floors.length; i += 2) {
      floors.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FloorCard(occupation.getFloor(i)),
            FloorCard(occupation.getFloor(i + 1))
          ]));
    }
    return Column(
      children: floors,
    );
  }
}

class FloorCard extends StatelessWidget {
  final FloorOccupation floor;

  const FloorCard(this.floor, {super.key});

  @override
  Widget build(BuildContext context) {
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
            style: Theme.of(context).textTheme.headline5),
        Text('${floor.percentage}%',
            style: Theme.of(context).textTheme.headline6),
        Text('${floor.occupation}/${floor.capacity}',
            style: Theme.of(context)
                .textTheme
                .headline6
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
