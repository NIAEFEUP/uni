import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/entities/reference.dart';
import 'package:uni/model/providers/profile_state_provider.dart';
import 'package:uni/model/providers/reference_provider.dart';
import 'package:uni/view/common_widgets/generic_card.dart';
import 'package:uni/view/profile/widgets/reference_section.dart';
import 'package:uni/view/profile/widgets/tuition_notification_switch.dart';

/// Manages the 'Current account' section inside the user's page (accessible
/// through the top-right widget with the user picture)
class AccountInfoCard extends GenericCard {
  AccountInfoCard({Key? key}) : super(key: key);

  const AccountInfoCard.fromEditingInformation(
      Key key, bool editingMode, Function()? onDelete)
      : super.fromEditingInformation(key, editingMode, onDelete);

  @override
  Widget buildCardContent(BuildContext context) {
    return Consumer2<ProfileStateProvider, ReferenceProvider>(
      builder: (context, profileStateProvider, referenceProvider, _) {
        final profile = profileStateProvider.profile;
        final List<Reference> references = referenceProvider.references;

        return Column(children: [
          Table(
              columnWidths: const {1: FractionColumnWidth(.4)},
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(children: [
                  Container(
                    margin: const EdgeInsets.only(
                        top: 20.0, bottom: 8.0, left: 20.0),
                    child: Text('Saldo: ',
                        style: Theme.of(context).textTheme.titleSmall),
                  ),
                  Container(
                      margin: const EdgeInsets.only(
                          top: 20.0, bottom: 8.0, right: 30.0),
                      child: getInfoText(profile.feesBalance, context))
                ]),
                TableRow(children: [
                  Container(
                    margin: const EdgeInsets.only(
                        top: 8.0, bottom: 20.0, left: 20.0),
                    child: Text('Data limite próxima prestação: ',
                        style: Theme.of(context).textTheme.titleSmall),
                  ),
                  Container(
                      margin: const EdgeInsets.only(
                          top: 8.0, bottom: 20.0, right: 30.0),
                      child: getInfoText(profile.feesLimit, context))
                ]),
                TableRow(children: [
                  Container(
                    margin:
                        const EdgeInsets.only(top: 8.0, bottom: 20.0, left: 20.0),
                    child: Text("Notificar próxima data limite: ",
                      style: Theme.of(context).textTheme.titleSmall)
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(top: 8.0, bottom: 20.0, left: 20.0),
                    child: 
                      const TuitionNotificationSwitch()
                  )
                ])
              ]),
          Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                  children: <Widget>[
                    Text('Referências pendentes',
                        style: Theme.of(context).textTheme.titleLarge
                            ?.apply(color: Theme.of(context).colorScheme.secondary)),
                  ]
              )
          ),
          ReferenceWidgets(references: references),
          const SizedBox(
              height: 10
          ),
          showLastRefreshedTime(profileStateProvider.feesRefreshTime, context)
        ]);
      },
    );
  }

  @override
  String getTitle() => 'Conta Corrente';

  @override
  onClick(BuildContext context) {}
}

class ReferenceWidgets extends StatelessWidget {
  final List<Reference> references;

  const ReferenceWidgets({Key? key, required this.references}): super(key: key);

  @override
  Widget build(BuildContext context) {
    if (references.isEmpty) {
      return Text(
        "Não existem referências a pagar",
        style: Theme.of(context).textTheme.headlineSmall,
        textScaleFactor: 0.9,
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
        ]
    );
  }
}
