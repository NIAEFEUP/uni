import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/library_occupation.dart';
import 'package:uni/model/providers/lazy/library_occupation_provider.dart';
import 'package:uni/view/home/widgets2/generic_home_card.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni_ui/cards/library_occupation_card.dart';

class LibraryHomeCard extends GenericHomecard {
  const LibraryHomeCard({super.key, required super.title});

  @override
  void onClick(BuildContext context) => {};

  @override
  Widget buildCardContent(BuildContext context) {
    return LazyConsumer<LibraryOccupationProvider, LibraryOccupation>(
      builder: (context, libraryOccupation) => LibraryOccupationCard(
        capacity: libraryOccupation.capacity,
        occupation: libraryOccupation.occupation,
        occupationWidgetsList:
            buildFloorOccupation(context, libraryOccupation.floors),
      ),
      hasContent: (libraryOccupation) => true,
      onNullContent: const CircularProgressIndicator(),
    );
  }
}

List<FloorOccupationWidget> buildFloorOccupation(
  BuildContext context,
  List<FloorOccupation> floors,
) {
  final items = floors
      .map(
        (floor) => FloorOccupationWidget(
          capacity: floor.capacity,
          occupation: floor.occupation,
          floorText: S.of(context).floor,
          floorNumber: floor.number,
        ),
      )
      .toList();

  return items;
}

/*

class FloorOccupationWidget extends StatelessWidget {
  final int capacity;
  final int occupation;
  final String floorText;
  final int floorNumber;

*/
