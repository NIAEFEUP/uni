class Unpaid {
  Unpaid({
    required this.status,
    required this.acronym,
    required this.description,
    required this.date,
    required this.deadline,
    required this.value,
    this.amountPaid,
    required this.amountDue,
    this.interestOnLatePayment,
  });

  final String status;
  final String acronym;
  final String description;
  final DateTime date;
  final DateTime deadline;
  final int value;
  final int? amountPaid;
  final int amountDue;
  final int? interestOnLatePayment;
}

class Transaction {
  Transaction({
    this.process,
    this.acronym,
    required this.description,
    required this.date,
    this.deadline,
    this.debit,
    this.credit,
    this.missingDebit,
    this.interestOnLatePayment,
    required this.status,
    required this.document,
  });

  final String? process;
  final String? acronym;
  final String description;
  final DateTime date;
  final DateTime? deadline;
  final int? debit;
  final int? credit;
  final int? missingDebit;
  final int? interestOnLatePayment;
  final String status;
  final String document;
}

class AccountStatement {
  AccountStatement({
    required this.description,
    required this.date,
    this.debit,
    this.credit,
  });

  final String description;
  final DateTime date;
  final int? debit;
  final int? credit;
}
