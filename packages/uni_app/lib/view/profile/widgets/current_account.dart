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
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Center(
                child: Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color.fromARGB(255, 246, 220, 220),
                  ),
                  child: _FilterBar(
                    selected: _selectedTab,
                    onSelected: (index) => setState(() {
                      _selectedTab = index;
                    }),
                  ),
                ),
              ),
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
      dropdownColor: const Color.fromARGB(255, 255, 210, 210),
      style: const TextStyle(color: Colors.black),
      decoration: const InputDecoration(border: InputBorder.none),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color.fromARGB(255, 239, 131, 124),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: constraints.maxWidth - 40,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(
                      const Color.fromARGB(255, 255, 210, 210),
                    ),
                    headingTextStyle: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 246, 220, 220),
                      borderRadius: BorderRadius.circular(8),
                    ),
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
                              DataCell(
                                Text(
                                  DateFormat('dd-MM-yyyy').format(item.date),
                                ),
                              ),
                              DataCell(
                                Text(
                                  item.deadline != null
                                      ? DateFormat(
                                          'dd-MM-yyyy',
                                        ).format(item.deadline!)
                                      : '-',
                                ),
                              ),
                              DataCell(Text('${item.value / 100} €')),
                              DataCell(
                                Text(
                                  item.amountPaid != null
                                      ? '${item.amountPaid! / 100} €'
                                      : '-',
                                ),
                              ),
                              DataCell(Text('${item.amountDue / 100} €')),
                              DataCell(
                                Text(
                                  item.interestOnLatePayment != null
                                      ? '${item.interestOnLatePayment! / 100} €'
                                      : '-',
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class TransactionsTable extends StatelessWidget {
  const TransactionsTable({super.key, required this.data});

  final List<Transaction> data;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color.fromARGB(255, 239, 131, 124),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: constraints.maxWidth - 40,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(
                      const Color.fromARGB(255, 255, 210, 210),
                    ),
                    headingTextStyle: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 246, 220, 220),
                      borderRadius: BorderRadius.circular(8),
                    ),
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
                              DataCell(
                                Text(
                                  DateFormat('dd-MM-yyyy').format(item.date),
                                ),
                              ),
                              DataCell(
                                Text(
                                  item.deadline != null
                                      ? DateFormat(
                                          'dd-MM-yyyy',
                                        ).format(item.deadline!)
                                      : '-',
                                ),
                              ),
                              DataCell(
                                Text(
                                  item.debit != null
                                      ? '${item.debit! / 100} €'
                                      : '-',
                                ),
                              ),
                              DataCell(
                                Text(
                                  item.credit != null
                                      ? '${item.credit! / 100} €'
                                      : '-',
                                ),
                              ),
                              DataCell(
                                Text(
                                  item.missingDebit != null
                                      ? '${item.missingDebit! / 100} €'
                                      : '-',
                                ),
                              ),
                              DataCell(
                                Text(
                                  item.interestOnLatePayment != null
                                      ? '${item.interestOnLatePayment! / 100} €'
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
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class AccountStatementTable extends StatelessWidget {
  const AccountStatementTable({super.key, required this.data});

  final List<AccountStatement> data;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color.fromARGB(255, 239, 131, 124),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: constraints.maxWidth - 40,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(
                      const Color.fromARGB(255, 255, 210, 210),
                    ),
                    headingTextStyle: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 246, 220, 220),
                      borderRadius: BorderRadius.circular(8),
                    ),
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
                              DataCell(
                                Text(
                                  DateFormat('dd-MM-yyyy').format(item.date),
                                ),
                              ),
                              DataCell(
                                Text(
                                  item.debit != null
                                      ? '${item.debit! / 100} €'
                                      : '-',
                                ),
                              ),
                              DataCell(
                                Text(
                                  item.credit != null
                                      ? '${item.credit! / 100} €'
                                      : '-',
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
