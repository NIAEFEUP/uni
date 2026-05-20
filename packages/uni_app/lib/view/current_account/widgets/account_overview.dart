import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni_ui/cards/generic_card.dart';
import 'package:uni_ui/cards/profile_list_tile.dart';
import 'package:uni_ui/icons.dart';

class AccountOverview extends StatelessWidget {
  const AccountOverview({
    super.key,
    required this.feesBalance,
    this.feesLimit,
    required this.printBalance,
  });

  final String feesBalance;
  final DateTime? feesLimit;
  final String printBalance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GenericCard(
          tooltip: S.of(context).balance,
          margin: const EdgeInsets.only(bottom: 14, right: 20, left: 20),
          padding: EdgeInsets.zero,
          child: ProfileListTile(
            icon: UniIcons.piggyBank,
            title: S.of(context).balance,
            subtitle: S.of(context).balance_description,
            trailing: Text(
              feesBalance,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
        GenericCard(
          tooltip: S.of(context).fee_date,
          margin: const EdgeInsets.only(bottom: 14, right: 20, left: 20),
          padding: EdgeInsets.zero,
          child: ProfileListTile(
            icon: UniIcons.calendarDots,
            title: S.of(context).fee_date,
            subtitle: S.of(context).fee_date_description,
            trailing: Text(
              feesLimit != null
                  ? DateFormat('yyyy-MM-dd').format(feesLimit!)
                  : S.of(context).no_date,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
        GenericCard(
          tooltip: S.of(context).print_balance,
          margin: const EdgeInsets.only(bottom: 14, right: 20, left: 20),
          padding: EdgeInsets.zero,
          child: ProfileListTile(
            icon: UniIcons.printer,
            title: S.of(context).print_balance,
            subtitle: S.of(context).print_balance_description,
            trailing: Text(
              printBalance,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
      ],
    );
  }
}
