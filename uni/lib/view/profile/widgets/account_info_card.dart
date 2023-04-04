import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/entities/reference.dart';
import 'package:uni/model/providers/profile_state_provider.dart';
import 'package:uni/model/providers/reference_provider.dart';
import 'package:uni/view/common_widgets/generic_card.dart';
import 'package:uni/view/profile/widgets/reference_card.dart';
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
        final Widget referenceCards;

        if (references.isEmpty) {
          referenceCards = Text(
            "Não existem referências a pagar",
            style: Theme.of(context).textTheme.subtitle2,
            textScaleFactor: 0.9,
          );
        } else {
          referenceCards = Column(
              children: (references.sublist(0, 2).map((reference) {
                return ReferenceCard(reference: reference);
              })).toList()
          );
        }

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
                    Text('Referências',
                        style: Theme.of(context).textTheme.headline6
                            ?.apply(color: Theme.of(context).colorScheme.secondary)),
                  ]
              )
          ),
          referenceCards,
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
