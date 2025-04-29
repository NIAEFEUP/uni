import 'package:json_annotation/json_annotation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:uni/model/converters/date_time_converter.dart';

part '../../generated/model/entities/reference.g.dart';

@DateTimeConverter()
@JsonSerializable()
@Entity()
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

  @Id()
  int? id;
  final String description;
  final DateTime limitDate;
  final int entity;
  final int reference;
  final double amount;

  Map<String, dynamic> toJson() => _$ReferenceToJson(this);
}
