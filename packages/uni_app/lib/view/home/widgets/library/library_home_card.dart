import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/floor_occupation.dart';
import 'package:uni/model/entities/library_occupation.dart';
import 'package:uni/model/providers/lazy/library_occupation_provider.dart';
import 'package:uni/view/common_widgets/icon_label.dart';
import 'package:uni/view/home/widgets/generic_home_card.dart';
import 'package:uni/view/home/widgets/library/library_card_shimmer.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni_ui/cards/library_occupation_card.dart';
import 'package:uni_ui/icons.dart';

class LibraryHomeCard extends GenericHomecard {
  const LibraryHomeCard({
    super.key,
    super.title = 'Library Occupation',
  });

  @override
  void onCardClick(BuildContext context) => {};

  @override
  Widget buildCardContent(BuildContext context) {
    return LazyConsumer<LibraryOccupationProvider, LibraryOccupation>(
      builder: (context, libraryOccupation) => LibraryOccupationCard(
        capacity: libraryOccupation.capacity,
        occupation: libraryOccupation.occupation,
        occupationWidgetsList:
            buildFloorOccupation(context, libraryOccupation.floors),
      ),
      hasContent: (libraryOccupation) => libraryOccupation.capacity > 0,
      onNullContent: Center(
        child: IconLabel(
          icon: const Icon(
            UniIcons.library,
            size: 45,
          ),
          label: S.of(context).no_library_info,
          labelTextStyle: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      contentLoadingWidget: const ShimmerLibraryHomeCard(),
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
