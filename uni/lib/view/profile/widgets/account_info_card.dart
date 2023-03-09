import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/providers/profile_state_provider.dart';
import 'package:uni/view/common_widgets/generic_card.dart';
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
    return Consumer<ProfileStateProvider>(
      builder: (context, profileStateProvider, _) {
        final profile = profileStateProvider.profile;
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
                        style: Theme.of(context).textTheme.subtitle2),
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
                        style: Theme.of(context).textTheme.subtitle2),
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
                      style: Theme.of(context).textTheme.subtitle2)
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(top: 8.0, bottom: 20.0, left: 20.0),
                    child: 
                      const TuitionNotificationSwitch()
                  )
                ])
              ]),
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
