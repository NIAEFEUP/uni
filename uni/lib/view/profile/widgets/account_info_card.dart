import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/reference.dart';
import 'package:uni/model/providers/lazy/reference_provider.dart';
import 'package:uni/model/providers/startup/profile_provider.dart';
import 'package:uni/view/common_widgets/generic_card.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni/view/profile/widgets/reference_section.dart';

/// Manages the 'Current account' section inside the user's page (accessible
/// through the top-right widget with the user picture)
class AccountInfoCard extends GenericCard {
  AccountInfoCard({super.key});

  const AccountInfoCard.fromEditingInformation(
    super.key, {
    required super.editingMode,
    super.onDelete,
  }) : super.fromEditingInformation();

  @override
  void onRefresh(BuildContext context) {
    Provider.of<ProfileProvider>(context, listen: false).forceRefresh(context);
    Provider.of<ReferenceProvider>(context, listen: false)
        .forceRefresh(context);
  }

  @override
  Widget buildCardContent(BuildContext context) {
    return Column(
      children: [
        LazyConsumer<ProfileProvider, Profile>(
          builder: (context, profile) => Table(
            columnWidths: const {1: FractionColumnWidth(.4)},
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      top: 20,
                      bottom: 8,
                      left: 20,
                    ),
                    child: Text(
                      S.of(context).balance,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 20,
                      bottom: 8,
                      right: 30,
                    ),
                    child: getInfoText(profile.feesBalance, context),
                  ),
                ],
              ),
              TableRow(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      top: 8,
                      left: 20,
                    ),
                    child: Text(
                      S.of(context).fee_date,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 8,
                      right: 30,
                    ),
                    child: getInfoText(
                      profile.feesLimit != null
                          ? DateFormat('yyyy-MM-dd').format(profile.feesLimit!)
                          : S.of(context).no_date,
                      context,
                    ),
                  ),
                ],
              ),
            ],
          ),
          hasContent: (profile) => true,
          onNullContent: Container(),
        ),
        LazyConsumer<ReferenceProvider, List<Reference>>(
          builder: (context, references) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    top: 30,
                    bottom: 10,
                    right: 15,
                    left: 15,
                  ),
                  child: Row(
                    children: <Widget>[
                      Text(
                        S.of(context).pendent_references,
                        style: Theme.of(context).textTheme.titleLarge?.apply(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                    ],
                  ),
                ),
                ReferenceList(references: references),
              ],
            );
          },
          hasContent: (references) => references.isNotEmpty,
          onNullContent: Container(),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  @override
  String getTitle(BuildContext context) => S.of(context).account_card_title;

  @override
  void onClick(BuildContext context) {}
}

class ReferenceList extends StatelessWidget {
  const ReferenceList({required this.references, super.key});

  final List<Reference> references;

  @override
  Widget build(BuildContext context) {
    if (references.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          S.of(context).no_references,
          style: Theme.of(context).textTheme.titleSmall,
          textScaler: const TextScaler.linear(0.96),
        ),
      );
    }
    if (references.length == 1) {
      return ReferenceSection(reference: references[0]);
    }
    return Column(
      children: [
        ReferenceSection(reference: references[0]),
        const Divider(
          thickness: 1,
          indent: 30,
          endIndent: 30,
        ),
        ReferenceSection(reference: references[1]),
      ],
    );
  }
}
