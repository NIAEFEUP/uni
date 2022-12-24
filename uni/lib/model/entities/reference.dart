class Reference {
  late final String description;
  late final DateTime limitDate;
  late final int entity;
  late final int reference;
  late final double amount;

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