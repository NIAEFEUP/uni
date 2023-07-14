import 'package:json_annotation/json_annotation.dart';

part 'reference.g.dart';

@JsonSerializable()
class Reference {
  final String description;
  final DateTime limitDate;
  final int entity;
  final int reference;
  final double amount;

  Reference(this.description, this.limitDate,
      this.entity, this.reference, this.amount);

  factory Reference.fromJson(Map<String,dynamic> json) => _$ReferenceFromJson(json);
  Map<String, dynamic> toJson() => _$ReferenceToJson(this);
}