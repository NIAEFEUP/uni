import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/library_occupation.dart';
import 'package:uni/model/providers/lazy/library_occupation_provider.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/common_widgets/generic_card.dart';
import 'package:uni/view/lazy_consumer.dart';

/// Manages the library card section inside the personal area.
class LibraryOccupationCard extends GenericCard {
  LibraryOccupationCard({super.key});

  const LibraryOccupationCard.fromEditingInformation(
    super.key, {
    required super.editingMode,
    super.onDelete,
  }) : super.fromEditingInformation();

  @override
  String getTitle(BuildContext context) => S.of(context).library_occupation;

  @override
  Future<Object?> onClick(BuildContext context) =>
      Navigator.pushNamed(context, '/${NavigationItem.navLibrary.route}');

  @override
  void onRefresh(BuildContext context) {
    Provider.of<LibraryOccupationProvider>(context, listen: false)
        .forceRefresh(context);
  }

  @override
  Widget buildCardContent(BuildContext context) {
    return LazyConsumer<LibraryOccupationProvider, LibraryOccupation>(
      builder: (context, libraryOccupation) => generateOccupation(
        libraryOccupation,
        context,
      ),
      hasContent: (libraryOccupation) => true,
      onNullContent: const CircularProgressIndicator(),
    );
  }

  Widget generateOccupation(
    LibraryOccupation? occupation,
    BuildContext context,
  ) {
    if (occupation == null || occupation.capacity == 0) {
      return Center(
        child: Text(
          S.of(context).no_data,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: CircularPercentIndicator(
        radius: 40,
        lineWidth: 8,
        percent: occupation.percentage / 100,
        center: Text(
          '${occupation.percentage}%',
          style: Theme.of(context)
              .textTheme
              .displayMedium
              ?.copyWith(fontSize: 23, fontWeight: FontWeight.w500),
        ),
        footer: Column(
          children: [
            const Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 0)),
            Text(
              '${occupation.occupation}/${occupation.capacity}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
        circularStrokeCap: CircularStrokeCap.square,
        backgroundColor: Theme.of(context).dividerColor,
        progressColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
