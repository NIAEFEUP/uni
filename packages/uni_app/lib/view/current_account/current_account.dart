import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/current_account.dart';
import 'package:uni/model/providers/riverpod/current_account_provider.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/current_account/widgets/transaction.dart';
import 'package:uni/view/widgets/pages_layouts/secondary/secondary.dart';

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

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color.fromARGB(255, 246, 220, 220),
                ),
                child: _FilterBar(
                  selected: _selectedTab,
                  onSelected: (index) => setState(() => _selectedTab = index),
                ),
              ),
            ),
            Expanded(child: _buildListView(currentList)),
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
      items: const [
        DropdownMenuItem(value: 0, child: Text('Pendentes')),
        DropdownMenuItem(value: 1, child: Text('Propinas')),
        DropdownMenuItem(value: 2, child: Text('Histórico Geral')),
      ],
      onChanged: (index) {
        if (index != null) onSelected(index);
      },
    );
  }
}
