import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/providers/profile_state_provider.dart';
import 'package:uni/view/common_widgets/generic_card.dart';
import 'package:uni/view/profile/widgets/create_print_mb_dialog.dart';

class PrintInfoCard extends GenericCard {
  PrintInfoCard({Key? key}) : super(key: key);

  const PrintInfoCard.fromEditingInformation(
      Key key, bool editingMode, Function()? onDelete)
      : super.fromEditingInformation(key, editingMode, onDelete);

  @override
  Widget buildCardContent(BuildContext context) {
    return Consumer<ProfileStateProvider>(
      builder: (context, profileStateProvider, _) {
        final profile = profileStateProvider.profile;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Table(
                columnWidths: const {
                  1: FractionColumnWidth(0.4),
                  2: FractionColumnWidth(.1)
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(children: [
                    Container(
                      margin: const EdgeInsets.only(
                          top: 20.0, bottom: 20.0, left: 20.0),
                      child: Text('Valor disponível: ',
                          style: Theme.of(context).textTheme.titleSmall),
                    ),
                    Container(
                        margin: const EdgeInsets.only(right: 15.0),
                        child: Text(profile.printBalance,
                            textAlign: TextAlign.end,
                            style: Theme.of(context).textTheme.titleLarge)),
                    Container(
                        margin: const EdgeInsets.only(right: 5.0),
                        height: 30,
                        child: ElevatedButton(
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          onPressed: () => addMoneyDialog(context),
                          child: const Center(child: Icon(Icons.add)),
                        )
                    ),
                  ])
                ]),
            showLastRefreshedTime(
                profileStateProvider.printRefreshTime, context)
          ],
        );
      },
    );
  }

  @override
  String getTitle(context) => 'Impressões';

  @override
  onClick(BuildContext context) {}
}
