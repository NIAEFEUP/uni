import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/entities/library_occupation.dart';
import 'package:uni/model/providers/lazy/library_occupation_provider.dart';
import 'package:uni/model/request_status.dart';
import 'package:uni/view/common_widgets/page_title.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni/view/library/widgets/library_occupation_card.dart';

class LibraryOccupationTab extends StatefulWidget {
  const LibraryOccupationTab({super.key});

  @override
  LibraryOccupationTabState createState() => LibraryOccupationTabState();

  Future<void> refresh(BuildContext context) async {
    await Provider.of<LibraryOccupationProvider>(context, listen: false)
        .forceRefresh(context);
  }
}

class LibraryOccupationTabState extends State<LibraryOccupationTab> {
  @override
  Widget build(BuildContext context) {
    return LazyConsumer<LibraryOccupationProvider>(
        builder: (context, occupationProvider) {
      if (occupationProvider.status == RequestStatus.busy) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return LibraryOccupationTabView(occupationProvider.occupation);
      }
    },);
  }
}

class LibraryOccupationTabView extends StatelessWidget {

  const LibraryOccupationTabView(this.occupation, {super.key});
  final LibraryOccupation? occupation;

  @override
  Widget build(BuildContext context) {
    if (occupation == null || occupation?.capacity == 0) {
      return ListView(children: [
        Center(
            heightFactor: 2,
            child: Text('Não existem dados para apresentar',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,),)
      ],);
    }
    return ListView(
        shrinkWrap: true,
        children: [
          LibraryOccupationCard(),
          if (occupation != null) ...[
            const PageTitle(name: 'Pisos'),
            FloorRows(occupation!),
          ]
        ],);
  }
}

class FloorRows extends StatelessWidget {

  const FloorRows(this.occupation, {super.key});
  final LibraryOccupation occupation;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 25),
      crossAxisSpacing: 25,
      mainAxisSpacing: 5,
      physics: const NeverScrollableScrollPhysics(),
      children: occupation.floors.map(FloorCard.new).toList(),
    );
  }
}

class FloorCard extends StatelessWidget {

  const FloorCard(this.floor, {super.key});
  final FloorOccupation floor;

  @override
  Widget build(BuildContext context) {
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
            )
          ],),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Text('Piso ${floor.number}',
            style: Theme.of(context).textTheme.headlineSmall,),
        Text('${floor.percentage}%',
            style: Theme.of(context).textTheme.titleLarge,),
        Text('${floor.occupation}/${floor.capacity}',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Theme.of(context).colorScheme.background),),
        LinearPercentIndicator(
          lineHeight: 7,
          percent: floor.percentage / 100,
          progressColor: Theme.of(context).colorScheme.secondary,
          backgroundColor: Theme.of(context).dividerColor,
        )
      ],),
    );
  }
}
