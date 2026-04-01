import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/current_account.dart';
import 'package:uni/model/providers/riverpod/current_account_provider.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/current_account/account_overview.dart';
import 'package:uni/view/current_account/widgets/transaction.dart';
import 'package:uni/view/widgets/pages_layouts/secondary/secondary.dart';
import 'package:uni_ui/cards/generic_card.dart';
import 'package:uni_ui/cards/profile_list_tile.dart';
import 'package:uni_ui/icons.dart';

class CurrentAccountPageView extends ConsumerStatefulWidget {
  const CurrentAccountPageView({super.key});

  @override
  ConsumerState<CurrentAccountPageView> createState() =>
      CurrentAccountPageViewState();
}

class CurrentAccountPageViewState
    extends SecondaryPageViewState<CurrentAccountPageView> {
  int _selectedTab = 0;

  @override
  String? getTitle() =>
      S.of(context).nav_title(NavigationItem.navCurrentAccount.route);

  @override
  Future<void> onRefresh() async {}

  List<dynamic> _filterTuition(
    List<Unpaid> unpaid,
    List<AccountStatement> statement,
  ) {
    final List<dynamic> combined =
        [
          ...unpaid.where(
            (e) => e.description.toLowerCase().contains('propina'),
          ),
          ...statement.where(
            (e) => e.description.toLowerCase().contains('propina'),
          ),
        ]..sort((a, b) {
          final dateA = (a is Unpaid) ? a.date : (a as AccountStatement).date;
          final dateB = (b is Unpaid) ? b.date : (b as AccountStatement).date;
          return dateB.compareTo(dateA);
        });

    return combined;
  }

  Widget _buildListView(List<dynamic> items) {
    if (items.isEmpty) {
      return const Center(child: Text("Sem registos para este filtro."));
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = items[index];

        if (item is Unpaid) {
          return Transaction(
            description: item.description,
            date: item.date,
            deadline: item.deadline,
            value: item.amountDue,
            interestOnLatePayment: item.interestOnLatePayment,
            paymentLink: item.paymentLink,
            isUnpaid: true,
          );
        } else if (item is AccountStatement) {
          return Transaction(
            description: item.description,
            date: item.date,
            value: item.credit,
            isUnpaid: false,
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  @override
  Widget getBody(BuildContext context) {
    final currentAccount = ref.watch(currentAccountProvider);

    return currentAccount.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (data) {
        final unpaid = data.$1;
        final history = data.$2;

        final nextItem = unpaid.isNotEmpty ? unpaid.first : null;

        List<dynamic> currentList;

        switch (_selectedTab) {
          case 0:
            currentList = unpaid;
            break;
          case 1:
            currentList = _filterTuition(unpaid, history);
            break;
          case 2:
            currentList = history;
            break;
          default:
            currentList = [];
        }

        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                S.of(context).overview,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            const SizedBox(height: 8),
            const AccountOverview(),
            const SizedBox(height: 8),
            if (nextItem != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  S.of(context).upcoming_due,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Transaction(
                  description: nextItem.description,
                  date: nextItem.date,
                  deadline: nextItem.deadline,
                  value: nextItem.amountDue,
                  interestOnLatePayment: nextItem.interestOnLatePayment,
                  paymentLink: nextItem.paymentLink,
                  isUnpaid: true,
                ),
              ),
            ],
            const SizedBox(height: 22),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    S.of(context).transactions,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),
                const SizedBox(width: 14),
              ],
            ),
            const SizedBox(height: 8),
            if (currentList.isEmpty)
              const Center(child: Text("Sem registos."))
            else
              _buildListView(currentList),
          ],
        );
      },
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.selected, required this.onSelected});

  final int selected;
  final void Function(int) onSelected;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      dropdownColor: const Color.fromARGB(255, 255, 210, 210),
      style: const TextStyle(color: Colors.black),
      decoration: const InputDecoration(border: InputBorder.none),
      initialValue: selected,
      items: [
        DropdownMenuItem(value: 0, child: Text(S.of(context).pending)),
        DropdownMenuItem(value: 1, child: Text(S.of(context).tuition_fees)),
        DropdownMenuItem(value: 2, child: Text(S.of(context).general_history)),
      ],
      onChanged: (index) {
        if (index != null) onSelected(index);
      },
    );
  }
}
