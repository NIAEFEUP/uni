import 'package:objectbox/objectbox.dart';

enum TransactionType {
  certificate,
  latePayementInterest,
  tuitionFees,
  schoolInsurance,
}

@Entity()
class Unpaid {
  Unpaid({
    this.id = 0,
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

  @Id()
  int id;

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

@Entity()
class Transaction {
  Transaction({
    this.id = 0,
    required this.typeIndex,
    required this.process,
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

  @Id()
  int id;

  int typeIndex;

  TransactionType get type => TransactionType.values[typeIndex];
  set type(TransactionType t) => typeIndex = t.index;

  final int process;
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

@Entity()
class AccountStatement {
  AccountStatement({
    this.id = 0,
    required this.description,
    required this.date,
    this.debit,
    this.credit,
  });

  @Id()
  int id;

  final String description;
  final DateTime date;
  final int? debit;
  final int? credit;
}
