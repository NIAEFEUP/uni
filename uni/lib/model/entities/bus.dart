/// Stores information about a bus.
///
/// Stores the bus code (`busCode`), the `destination` of the bus
/// and its `direction`.
class Bus {

  Bus(
      {required this.busCode,
      required this.destination,
      this.direction = false,});
  String busCode;
  String destination;
  bool direction;

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
