
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uni/model/entities/current_account.dart';
import 'package:uni/model/providers/riverpod/current_account_provider.dart';

class CurrentAccountInfo extends ConsumerStatefulWidget {
  const CurrentAccountInfo({super.key});

  @override
  ConsumerState<CurrentAccountInfo> createState() => _CurrentAccountInfo();
}

class _CurrentAccountInfo extends ConsumerState<CurrentAccountInfo> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final currentAccount = ref.watch(currentAccountProvider);

    return currentAccount.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Text('Error: $err'),
      data: (data) {
        final (
          unpaid,
          certificate,
          latePaymentInterest,
          tuitionFees,
          schoolInsurance,
          accountStatement,
        ) = data;

        return Column(
          children: [
            _FilterBar(
              selected: _selectedTab,
              onSelected: (index) => setState(() {
                _selectedTab = index;
              }),
            ),
            if (_selectedTab == 0) UnpaidTable(data: unpaid),
            if (_selectedTab == 1) TransactionsTable(data: certificate),
            if (_selectedTab == 2) TransactionsTable(data: latePaymentInterest),
            if (_selectedTab == 3) TransactionsTable(data: tuitionFees),
            if (_selectedTab == 4) TransactionsTable(data: schoolInsurance),
            if (_selectedTab == 5)
              AccountStatementTable(data: accountStatement),
          ],
        );
      },
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.selected, required this.onSelected});

  final int selected;
  final Function(int) onSelected;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      initialValue: selected,
      items: const [
        DropdownMenuItem(value: 0, child: Text('Unpaid expenses')),
        DropdownMenuItem(value: 1, child: Text('Certificate')),
        DropdownMenuItem(value: 2, child: Text('Late Payment Interest')),
        DropdownMenuItem(value: 3, child: Text('Tuition Fees')),
        DropdownMenuItem(value: 4, child: Text('School Insurance')),
        DropdownMenuItem(value: 5, child: Text('Account Statement')),
      ],
      onChanged: (index) {
        if (index != null) onSelected(index);
      },
    );
  }
}

class UnpaidTable extends StatelessWidget {
  const UnpaidTable({super.key, required this.data});

  final List<Unpaid> data;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        decoration: BoxDecoration(color: Colors.white, border: Border.all()),
        columns: const [
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Acronym')),
          DataColumn(label: Text('Description')),
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Deadline')),
          DataColumn(label: Text('Value')),
          DataColumn(label: Text('Amount Paid')),
          DataColumn(label: Text('Amount Due')),
          DataColumn(label: Text('Interest on late payments')),
        ],
        rows: data
            .whereType<Unpaid>()
            .map(
              (item) => DataRow(
                cells: [
                  DataCell(Text(item.status)),
                  DataCell(Text(item.acronym)),
                  DataCell(Text(item.description)),
                  DataCell(Text(DateFormat('dd-MM-yyyy').format(item.date))),
                  DataCell(
                    Text(DateFormat('dd-MM-yyyy').format(item.deadline)),
                  ),
                  DataCell(Text('${item.value} €')),
                  DataCell(
                    Text(
                      item.amountPaid != null ? '${item.amountPaid} €' : '-',
                    ),
                  ),
                  DataCell(Text('${item.amountDue} €')),
                  DataCell(
                    Text(
                      item.interestOnLatePayment != null
                          ? '${item.interestOnLatePayment} €'
                          : '-',
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}

class TransactionsTable extends StatelessWidget {
  const TransactionsTable({super.key, required this.data});

  final List<Transaction> data;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Process')),
          DataColumn(label: Text('Acronym')),
          DataColumn(label: Text('Description')),
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Deadline')),
          DataColumn(label: Text('Debit')),
          DataColumn(label: Text('Credit')),
          DataColumn(label: Text('Missing debit')),
          DataColumn(label: Text('Interest on late payments')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Document')),
        ],
        rows: data
            .whereType<Transaction>()
            .map(
              (item) => DataRow(
                cells: [
                  DataCell(Text(item.process ?? '-')),
                  DataCell(Text(item.acronym ?? '-')),
                  DataCell(Text(item.description)),
                  DataCell(Text(DateFormat('dd-MM-yyyy').format(item.date))),
                  DataCell(
                    Text(
                      item.deadline != null
                          ? DateFormat('dd-MM-yyyy').format(item.deadline!)
                          : '-',
                    ),
                  ),
                  DataCell(Text(item.debit != null ? '${item.debit} €' : '-')),
                  DataCell(
                    Text(item.credit != null ? '${item.credit} €' : '-'),
                  ),
                  DataCell(
                    Text(
                      item.missingDebit != null
                          ? '${item.missingDebit} €'
                          : '-',
                    ),
                  ),
                  DataCell(
                    Text(
                      item.interestOnLatePayment != null
                          ? '${item.interestOnLatePayment} €'
                          : '-',
                    ),
                  ),
                  DataCell(Text(item.status)),
                  DataCell(Text(item.document)),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}

class AccountStatementTable extends StatelessWidget {
  const AccountStatementTable({super.key, required this.data});

  final List<AccountStatement> data;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Description')),
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Debit')),
          DataColumn(label: Text('Credit')),
        ],
        rows: data
            .whereType<AccountStatement>()
            .map(
              (item) => DataRow(
                cells: [
                  DataCell(Text(item.description)),
                  DataCell(Text(DateFormat('dd-MM-yyyy').format(item.date))),
                  DataCell(Text(item.debit != null ? '${item.debit} €' : '-')),
                  DataCell(
                    Text(item.credit != null ? '${item.credit} €' : '-'),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}
