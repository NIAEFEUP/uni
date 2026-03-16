enum ParkingLotType { permanentStaff, students, nonPermanentStaff }

class ParkingLot {
  ParkingLot({
    required this.id,
    required this.type,
    required this.capacity,
    required this.occupied,
    required this.free,
  });

  final String id;
  final ParkingLotType type;
  final int capacity;
  final int occupied;
  final int free;

  double get occupancyRatio => capacity > 0 ? occupied / capacity : 0.0;
}

class ParkingLotOccupation {
  ParkingLotOccupation(this.lots);

  final List<ParkingLot> lots;
}
