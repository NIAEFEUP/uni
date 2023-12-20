import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/providers/startup/profile_provider.dart';
import 'package:uni/view/common_widgets/generic_card.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni/view/profile/widgets/create_print_mb_dialog.dart';

class PrintInfoCard extends GenericCard {
  PrintInfoCard({super.key});

  const PrintInfoCard.fromEditingInformation(
    super.key, {
    required super.editingMode,
    super.onDelete,
  }) : super.fromEditingInformation();

  @override
  Widget buildCardContent(BuildContext context) {
    return LazyConsumer<ProfileProvider, Profile>(
      builder: getPrintInfo,
      hasContent: (profile) => profile.printBalance != '',
      onNullContent: const Center(
        child: Text(
          S.of(context).no_print_info,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Widget getPrintInfo(BuildContext context, Profile profile) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Table(
          columnWidths: const {
            1: FractionColumnWidth(0.4),
            2: FractionColumnWidth(.1),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    top: 20,
                    bottom: 20,
                    left: 20,
                  ),
                  child: Text(
                    S.of(context).available_amount,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 15),
                  child: Text(
                    profile.printBalance,
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 5),
                  height: 30,
                  child: ElevatedButton(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () => addMoneyDialog(context),
                    child: const Center(child: Icon(Icons.add)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  @override
  String getTitle(BuildContext context) => S.of(context).prints;

  @override
  void onClick(BuildContext context) {}

  @override
  void onRefresh(BuildContext context) {
    Provider.of<ProfileProvider>(context, listen: false).forceRefresh(context);
  }
}
