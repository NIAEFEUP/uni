import 'package:flutter/widgets.dart';

/// Stores information about a bus.
///
/// Stores the bus code (`busCode`), the `destination` of the bus
/// and its `direction`.
class Bus {
  String busCode;
  String destination;
  bool direction;

  Bus(
      {@required this.busCode,
      this.destination = '',
      this.direction = false}) {}

  /// Converts a [Bus] instance to a map.
  ///
  /// The map contents are the `busCode`,
  /// the bus `destination` and its `direction`.
  Map<String, dynamic> toMap() {
    return {
      'busCode': busCode,
      'destination': destination,
      'direction': direction
    };
  }
}
