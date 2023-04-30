import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/providers/library_occupation_provider.dart';
import 'package:uni/model/request_status.dart';
import 'package:uni/utils/drawer_items.dart';
import 'package:uni/view/common_widgets/generic_card.dart';
import 'package:uni/view/common_widgets/request_dependent_widget_builder.dart';

/// Manages the library card section inside the personal area.
class LibraryOccupationCard extends GenericCard {
  LibraryOccupationCard({Key? key}) : super(key: key);

  const LibraryOccupationCard.fromEditingInformation(
      Key key, bool editingMode, Function()? onDelete)
      : super.fromEditingInformation(key, editingMode, onDelete);

  @override
  String getTitle() => 'Ocupação da Biblioteca';

  @override
  onClick(BuildContext context) =>
      Navigator.pushNamed(context, '/${DrawerItem.navLibrary.title}');

  @override
  Widget buildCardContent(BuildContext context) {
    return Consumer<LibraryOccupationProvider>(
        builder: (context, libraryOccupationProvider, _) =>
            RequestDependentWidgetBuilder(
                context: context,
                status: libraryOccupationProvider.status,
                contentGenerator: generateOccupation,
                content: libraryOccupationProvider.occupation,
                contentChecker:
                    libraryOccupationProvider.status != RequestStatus.busy,
                onNullContent: const CircularProgressIndicator()));
  }

  Widget generateOccupation(occupation, context) {
    if (occupation == null || occupation.capacity == 0) {
      return Center(
          child: Text('Não existem dados para apresentar',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center));
    }
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: CircularPercentIndicator(
          radius: 60.0,
          lineWidth: 8.0,
          percent: occupation.percentage / 100,
          center: Text('${occupation.percentage}%',
              style: Theme.of(context)
                  .textTheme
                  .displayMedium
                  ?.copyWith(fontSize: 23, fontWeight: FontWeight.w500)),
          footer: Column(
            children: [
              const Padding(padding: EdgeInsets.fromLTRB(0, 5.0, 0, 0)),
              Text('${occupation.occupation}/${occupation.capacity}',
                  style: Theme.of(context).textTheme.headlineSmall),
            ],
          ),
          circularStrokeCap: CircularStrokeCap.square,
          backgroundColor: Theme.of(context).dividerColor,
          progressColor: Theme.of(context).colorScheme.secondary,
        ));
  }
}
