import 'package:json_annotation/json_annotation.dart';

part 'bus.g.dart';

/// Stores information about a bus.
///
/// Stores the bus code (`busCode`), the `destination` of the bus
/// and its `direction`.
@JsonSerializable()
class Bus {
  Bus({
    required this.busCode,
    required this.destination,
    this.direction = false,
  });
  String busCode;
  String destination;
  bool direction;

  factory Bus.fromJson(Map<String, dynamic> json) => _$BusFromJson(json);
  Map<String, dynamic> toJson() => _$BusToJson(this);
}
