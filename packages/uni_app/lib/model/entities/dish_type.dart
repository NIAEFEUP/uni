class DishType {
  const DishType({
    required this.id,
    required this.keyLabel,
  });
  final int id;
  final String keyLabel;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DishType && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
