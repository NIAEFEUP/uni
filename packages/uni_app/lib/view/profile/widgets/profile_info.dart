import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/providers/startup/profile_provider.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni/view/profile/widgets/create_print_mb_dialog.dart';
import 'package:uni_ui/cards/profile_card.dart';

/// Manages the 'Current account' section inside the user's page (accessible
/// through the top-right widget with the user picture)
class ProfileInfo extends StatelessWidget {
  const ProfileInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return LazyConsumer<ProfileProvider, Profile>(
      builder: (context, profile) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ProfileCard(
            label: S.of(context).balance,
            content: profile.feesBalance,
            tooltip: S.of(context).balance,
          ),
          ProfileCard(
            label: S.of(context).fee_date,
            content: profile.feesLimit != null
                ? DateFormat('yyyy-MM-dd').format(profile.feesLimit!)
                : S.of(context).no_date,
            tooltip: S.of(context).fee_date,
          ),
          ProfileCard(
            label: S.of(context).print_balance,
            content: profile.printBalance,
            tooltip: S.of(context).print_balance,
            onClick: () => addMoneyDialog(context),
          ),
        ],
      ),
      hasContent: (profile) => true,
      onNullContent: Container(),
    );
  }
}
