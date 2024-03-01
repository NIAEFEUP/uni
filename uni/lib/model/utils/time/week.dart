/// A [Week] represents a period of 7 days.
class Week implements Comparable<Week> {
  /// Creates a [Week] that starts the given [start] **date** (not datetime).
  factory Week({
    required DateTime start,
  }) {
    final startAtMidnight = start.copyWith(
      hour: 0,
      minute: 0,
      second: 0,
      millisecond: 0,
      microsecond: 0,
    );

    final end = startAtMidnight.add(const Duration(days: 7));

    return Week._internal(startAtMidnight, end);
  }

  // Recommended by https://dart.dev/language/constructors#factory-constructors
  Week._internal(this.start, this.end);

  final DateTime start;
  final DateTime end;

  /// Returns whether the given [date] is within this [Week].
  bool contains(DateTime date) {
    // First check if is at the same time or after the start of the week.
    // Then check if is before the (exclusive) end of the week.
    return date.compareTo(start) >= 0 && date.isBefore(end);
  }

  /// Returns the [Week] that starts at the end of this [Week].
  Week next() {
    return Week._internal(end, end.add(const Duration(days: 7)));
  }

  /// Returns the [Week] that ends at the start of this [Week].
  Week previous() {
    return Week._internal(start.subtract(const Duration(days: 7)), start);
  }

  /// Returns the [Week] that is [duration] before this week.
  Week subtract(Duration duration) {
    final normalizedDuration = Duration(days: duration.inDays);
    return Week._internal(
      start.subtract(normalizedDuration),
      end.subtract(normalizedDuration),
    );
  }

  /// Returns the [Week] that is [duration] after this week.
  Week add(Duration duration) {
    final normalizedDuration = Duration(days: duration.inDays);
    return Week._internal(
      start.add(normalizedDuration),
      end.add(normalizedDuration),
    );
  }

  /// Returns the [Week] that starts at the given [weekday], contained in this
  /// [Week].
  ///
  /// The values for [weekday] are according to [DateTime.weekday].
  Week startingOn(int weekday) {
    // For instance, if [weekday] is 1 and [start] is on weekday 3,
    // the final offset in days should be 5, since the offset must not be
    // negative (the start of the returned week must be contained in this week).
    final offsetInDays = (weekday - start.weekday) % 7;

    return Week._internal(
      start.add(Duration(days: offsetInDays)),
      end.add(Duration(days: offsetInDays)),
    );
  }

  /// Returns the [Week] that ends (exclusive) at the given [weekday], contained
  /// in this [Week].
  ///
  /// The values for [weekday] are according to [DateTime.weekday].
  Week endingOn(int weekday) {
    // For instance, if [weekday] is 1 and [end] is on weekday 3,
    // the final offset in days should be 2.
    final offsetInDays = (end.weekday - weekday) % 7;

    return Week._internal(
      start.subtract(Duration(days: offsetInDays)),
      end.subtract(Duration(days: offsetInDays)),
    );
  }

  /// Returns the [DateTime] at the start of the given [weekday].
  ///
  /// The values for [weekday] are according to [DateTime.weekday].
  DateTime getWeekday(int weekday) {
    return start.add(Duration(days: (weekday - start.weekday) % 7));
  }

  Iterable<DateTime> get weekdays {
    return Iterable<DateTime>.generate(7, (index) => getWeekday(index + 1));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Week && other.start == start;
  }

  @override
  int get hashCode => start.hashCode;

  @override
  int compareTo(Week other) {
    return start.compareTo(other.start);
  }

  @override
  String toString() {
    return 'Week(start: $start, end: $end)';
  }
}
