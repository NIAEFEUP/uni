import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/providers/riverpod/default_consumer.dart';
import 'package:uni/model/providers/riverpod/profile_provider.dart';
// import 'package:uni/view/profile/widgets/create_print_mb_dialog.dart';
import 'package:uni_ui/cards/profile_card.dart';

/// Manages the 'Current account' section inside the user's page (accessible
/// through the top-right widget with the user picture)
class ProfileInfo extends ConsumerWidget {
  const ProfileInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultConsumer<Profile>(
      provider: profileProvider,
      builder: (context, ref, profile) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(width: 20),
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
                  // onClick: () => addMoneyDialog(context),
                ),
                const SizedBox(width: 20),
              ],
            ),
          ),
        ),
      ),
      nullContentWidget: Container(),
      hasContent: (profile) => true,
    );
  }
}
