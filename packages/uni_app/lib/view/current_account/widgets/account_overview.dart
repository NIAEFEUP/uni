import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/providers/riverpod/profile_provider.dart';
import 'package:uni_ui/cards/generic_card.dart';
import 'package:uni_ui/cards/profile_list_tile.dart';
import 'package:uni_ui/icons.dart';

class AccountOverview extends ConsumerWidget {
  const AccountOverview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overview = ref.watch(profileProvider);

    return overview.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (dynamic data) {
        final profile = data as Profile;

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
                  profile.feesBalance,
                  style: Theme.of(context).textTheme.headlineSmall,
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
                  profile.feesLimit != null
                      ? DateFormat('yyyy-MM-dd').format(profile.feesLimit!)
                      : S.of(context).no_date,
                  style: Theme.of(context).textTheme.headlineSmall,
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
                  profile.printBalance,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
