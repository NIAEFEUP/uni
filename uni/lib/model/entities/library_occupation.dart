/// Overall occupation of the library
class LibraryOccupation {
  int occupation = 0;
  int capacity = 0;
  List<FloorOccupation> floors = [];

  LibraryOccupation(this.occupation, this.capacity);

  void addFloor(FloorOccupation floor) {
    floors.add(floor);
    occupation += floor.occupation;
    capacity += floor.capacity;
  }

  int get percentage {
    if (capacity == 0) return 0;
    return (occupation * 100 / capacity).round();
  }

  FloorOccupation getFloor(int number) {
    if (floors.length < number || number < 0) return FloorOccupation(0, 0, 0);
    return floors[number - 1];
  }
}

/// Occupation values of a single floor
class FloorOccupation {
  final int number;
  final int occupation;
  final int capacity;

  FloorOccupation(this.number, this.occupation, this.capacity);

  int get percentage {
    if (capacity == 0) return 0;
    return (occupation * 100 / capacity).round();
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {
      'number': number,
      'occupation': occupation,
      'capacity': capacity,
    };
    return map;
  }
}
