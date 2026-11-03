class Unpaid {
  Unpaid({
    required this.description,
    required this.date,
    this.deadline,
    required this.value,
    required this.amountDue,
    this.interestOnLatePayment,
    this.paymentLink,
  });

  final String description;
  final DateTime date;
  final DateTime? deadline;
  final double value;
  final double amountDue;
  final double? interestOnLatePayment;
  final String? paymentLink;

  @override
  String toString() {
    return 'Unpaid(description: $description, date: $date, deadline: $deadline, value: $value, amountDue: $amountDue, interestOnLatePayment: $interestOnLatePayment)';
  }
}

class AccountStatement {
  AccountStatement({
    required this.description,
    required this.date,
    required this.credit,
  });

  final String description;
  final DateTime date;
  final double credit;

  @override
  String toString() {
    return 'AccountStatement(description: $description, date: $date, credit:$credit)';
  }
}
