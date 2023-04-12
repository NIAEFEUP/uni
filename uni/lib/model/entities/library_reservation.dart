/// Private room reservation from the library
class LibraryReservation {
  final String room;
  final DateTime startDate;
  final Duration duration;

  LibraryReservation(this.room, this.startDate, this.duration);

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {
      'room': room,
      'startDate': startDate.toIso8601String(),
      'duration': duration.inMinutes,
    };
    return map;
  }

  @override
  String toString() {
    return '$room, $startDate, $duration';
  }

  @override
  bool operator ==(Object other) {
    return other is LibraryReservation &&
        room == other.room &&
        (startDate.compareTo(other.startDate) == 0) &&
        (duration.compareTo(other.duration) == 0);
  }

  @override
  int get hashCode => Object.hash(room, startDate, duration);
}
