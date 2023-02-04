import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/reference.dart';
import 'package:uni/view/common_widgets/generic_card.dart';
import 'package:uni/view/profile/widgets/reference_card.dart';

/// Manages the 'Current account' section inside the user's page (accessible
/// through the top-right widget with the user picture)
class AccountInfoCard extends GenericCard {
  AccountInfoCard({Key? key}) : super(key: key);

  const AccountInfoCard.fromEditingInformation(
      Key key, bool editingMode, Function()? onDelete)
      : super.fromEditingInformation(key, editingMode, onDelete);

  @override
  Widget buildCardContent(BuildContext context) {
    return Column(children: [
      Table(
          columnWidths: const {1: FractionColumnWidth(.4)},
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(children: [
              Container(
                margin:
                    const EdgeInsets.only(top: 20.0, bottom: 8.0, left: 20.0),
                child: Text('Saldo: ',
                    style: Theme.of(context).textTheme.subtitle2),
              ),
              Container(
                margin:
                    const EdgeInsets.only(top: 20.0, bottom: 8.0, right: 30.0),
                child: StoreConnector<AppState, String?>(
                    converter: (store) => store.state.content['feesBalance'],
                    builder: (context, feesBalance) =>
                        getInfoText(feesBalance ?? '', context)),
              )
            ]),
            TableRow(children: [
              Container(
                margin:
                    const EdgeInsets.only(top: 8.0, bottom: 20.0, left: 20.0),
                child: Text('Data limite próxima prestação: ',
                    style: Theme.of(context).textTheme.subtitle2),
              ),
              Container(
                margin:
                    const EdgeInsets.only(top: 8.0, bottom: 20.0, right: 30.0),
                child: StoreConnector<AppState, String?>(
                    converter: (store) => store.state.content['feesLimit'],
                    builder: (context, feesLimit) =>
                        getInfoText(feesLimit ?? '', context)),
              )
            ]),
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
      StoreConnector<AppState, List<Reference>>(
          converter: (store) => store.state.content['references'],
          builder: (context, references) {
            return Column(
              children: (references.map((reference) {
                return ReferenceCard(reference: reference);
              })).toList()
            );
          }
      ),
      const SizedBox(
        height: 10
      ),
      StoreConnector<AppState, String?>(
          converter: (store) => store.state.content['feesRefreshTime'],
          builder: (context, feesRefreshTime) =>
              showLastRefreshedTime(feesRefreshTime, context))
    ]);
  }

  @override
  String getTitle() => 'Conta Corrente';

  @override
  onClick(BuildContext context) {}
}
