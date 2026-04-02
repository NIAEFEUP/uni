import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/current_account.dart';
import 'package:uni/model/providers/riverpod/current_account_provider.dart';
import 'package:uni/model/providers/riverpod/profile_provider.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/current_account/widgets/account_overview.dart';
import 'package:uni/view/current_account/widgets/current_account_shimmers.dart';
import 'package:uni/view/current_account/widgets/no_current_account.dart';
import 'package:uni/view/current_account/widgets/transaction.dart';
import 'package:uni/view/current_account/widgets/transaction_filter_menu.dart';
import 'package:uni/view/widgets/pages_layouts/secondary/secondary.dart';

class CurrentAccountPageView extends ConsumerStatefulWidget {
  const CurrentAccountPageView({super.key});

  @override
  ConsumerState<CurrentAccountPageView> createState() =>
      CurrentAccountPageViewState();
}

class CurrentAccountPageViewState
    extends SecondaryPageViewState<CurrentAccountPageView> {
  String _selectedFilter = 'Pending';

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
          final dateA = (a is Unpaid)
              ? (a.deadline ?? a.date)
              : (a as AccountStatement).date;
          final dateB = (b is Unpaid)
              ? (b.deadline ?? b.date)
              : (b as AccountStatement).date;
          return dateB.compareTo(dateA);
        });

    return combined;
  }

  Widget _buildListView(List<dynamic> items) {
    if (items.isEmpty) {
      return const Center(child: Text('Sem registos para este filtro.'));
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
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  @override
  Widget getBody(BuildContext context) {
    final currentAccount = ref.watch(currentAccountProvider);
    final accountOverview = ref.watch(profileProvider);

    if (currentAccount.isLoading || accountOverview.isLoading) {
      return const CurrentAccountShimmers();
    }

    if (currentAccount.hasError || accountOverview.hasError) {
      return LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            height: constraints.maxHeight,
            padding: const EdgeInsets.only(bottom: 120),
            child: Center(
              child: CurrentAccountNoInfo(
                label: S.of(context).no_info,
                sublabel: S.of(context).no_current_account_info,
              ),
            ),
          ),
        ),
      );
    }

    final unpaid = currentAccount.value!.$1;
    final history = currentAccount.value!.$2;

    final nextItem = unpaid.isNotEmpty ? unpaid.first : null;

    final p = accountOverview.value;

    List<dynamic> currentList;

    switch (_selectedFilter) {
      case 'Pending':
        currentList = unpaid;
      case 'Tuition Fees':
        currentList = _filterTuition(unpaid, history);
      case 'General History':
        currentList = history;
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
        AccountOverview(
          feesBalance: p!.feesBalance,
          feesLimit: p.feesLimit,
          printBalance: p.printBalance,
        ),
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
            Container(
              margin: const EdgeInsets.only(right: 20),
              child: TransactionFilterMenu(
                items: const ['Pending', 'Tuition Fees', 'General History'],
                selectedValue: _selectedFilter,
                onSelectionChanged: (newValue) {
                  setState(() {
                    _selectedFilter = newValue;
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (currentList.isEmpty)
          switch (_selectedFilter) {
            'Pending' => Transform.scale(
              scale: 0.8, // Encolhe o desenho em 20%
              child: CurrentAccountNoInfo(
                label: S.of(context).no_pending_label,
                sublabel: S.of(context).no_pending_sublabel,
              ),
            ),
            'Tuition Fees' => Transform.scale(
              scale: 0.8, // Encolhe o desenho em 20%
              child: CurrentAccountNoInfo(
                label: S.of(context).no_tuition_fees_label,
                sublabel: S.of(context).no_tuition_fees_sublabel,
              ),
            ),
            'General History' => Transform.scale(
              scale: 0.8, // Encolhe o desenho em 20%
              child: CurrentAccountNoInfo(
                label: S.of(context).no_history_label,
                sublabel: S.of(context).no_history_sublabel,
              ),
            ),
            _ => Transform.scale(
              scale: 0.8, // Encolhe o desenho em 20%
              child: CurrentAccountNoInfo(
                label: S.of(context).no_pending_label,
                sublabel: S.of(context).no_pending_sublabel,
              ),
            ),
          }
        else
          _buildListView(currentList),
      ],
    );
  }
}
