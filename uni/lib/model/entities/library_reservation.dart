/// Private room reservation from the library
class LibraryReservation {
  final String _id;
  final String room;
  final DateTime startDate;
  final Duration duration;

  LibraryReservation(this._id, this.room, this.startDate, this.duration);

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'id': id,
      'room': room,
      'startDate': startDate.toIso8601String(),
      'duration': duration.inMinutes,
    };
    return map;
  }

  String get id => _id;

  @override
  String toString() {
    return '$_id, $room, $startDate, $duration';
  }

  @override
  bool operator ==(Object other) {
    return other is LibraryReservation && _id == other.id;
  }

  @override
  int get hashCode => Object.hash(room, startDate, duration);
}
