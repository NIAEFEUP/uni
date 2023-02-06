class Reference {
  final String description;
  final DateTime limitDate;
  final int entity;
  final int reference;
  final double amount;

  Reference(this.description, this.limitDate,
      this.entity, this.reference, this.amount);

  /// Converts this reference to a map.
  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'limitDate': limitDate.toString(),
      'entity': entity,
      'reference': reference,
      'amount': amount,
    };
  }
}
