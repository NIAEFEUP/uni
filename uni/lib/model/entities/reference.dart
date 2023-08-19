import 'package:json_annotation/json_annotation.dart';

part 'reference.g.dart';

class DateTimeConverter extends JsonConverter<DateTime, String> {
  const DateTimeConverter();

  @override
  DateTime fromJson(String json) {
    return DateTime.parse(json);
  }

  @override
  String toJson(DateTime object) {
    return object.toString();
  }
}

@DateTimeConverter()
@JsonSerializable()
class Reference {
  Reference(
    this.description,
    this.limitDate,
    this.entity,
    this.reference,
    this.amount,
  );

  factory Reference.fromJson(Map<String, dynamic> json) =>
      _$ReferenceFromJson(json);
  final String description;
  final DateTime limitDate;
  final int entity;
  final int reference;
  final double amount;
  Map<String, dynamic> toJson() => _$ReferenceToJson(this);
}
