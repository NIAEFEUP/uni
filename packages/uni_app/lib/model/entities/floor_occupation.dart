import 'dart:math';

import 'package:json_annotation/json_annotation.dart';
import 'package:objectbox/objectbox.dart';

part '../../generated/model/entities/floor_occupation.g.dart';

@JsonSerializable()
@Entity()
class FloorOccupation {
  FloorOccupation(this.number, this.occupation, this.capacity);

  factory FloorOccupation.fromJson(Map<String, dynamic> json) =>
      _$FloorOccupationFromJson(json);

  @Id(assignable: true)
  int number;
  final int occupation;
  final int capacity;

  int get percentage {
    if (capacity <= 0) {
      return 0;
    }
    return min(100, (occupation * 100 / capacity).round());
  }

  Map<String, dynamic> toJson() => _$FloorOccupationToJson(this);
}
