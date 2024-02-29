/// A class that maps weekdays from one system to another.
///
/// ---
/// # Explanation
///
/// Consider the following systems:
///
/// | System | Mon | Tue | Wed | Thu | Fri | Sat | Sun |
/// |--------|-----|-----|-----|-----|-----|-----|-----|
/// | A      | 1   | 2   | 3   | 4   | 5   | 6   | 7   |
/// | B      | 0   | 1   | 2   | 3   | 4   | 5   | 6   |
/// | C      | 1   | 2   | 3   | 4   | 5   | 6   | 0   |
/// | D      | 5   | 6   | 0   | 1   | 2   | 3   | 4   |
/// | E      | 1   | 2   | 3   | 4   | 5   | -1  | 0   |
///
/// All of these systems are valid and used in different contexts. This class
/// allows for mapping weekdays from one system to another.
///
/// As you can see, a system is defined by two parameters: the number of the
/// first day of the week and the number of Monday (can be another day as long
/// as it is the same across all systems).
class WeekdayMapper {
  const WeekdayMapper({
    required int fromStart,
    required int fromMonday,
    required int toStart,
    required int toMonday,
  })  : _toMonday = toMonday,
        _toStart = toStart,
        _fromMonday = fromMonday,
        _fromStart = fromStart;

  /// Creates a [WeekdayMapper].
  ///
  /// [fromStartWeekday] and [toStartWeekday] are the weekdays that correspond
  /// to the first day of the week in the `from` and `to` systems, respectively.
  /// These values are according to [DateTime.weekday].
  const WeekdayMapper.fromStartWeekdays({
    required int fromStart,
    required int fromStartWeekday,
    required int toStart,
    required int toStartWeekday,
  }) : this(
          fromStart: fromStart,
          fromMonday: (DateTime.monday - fromStartWeekday) % 7 + fromStart,
          toStart: toStart,
          toMonday: (DateTime.monday - toStartWeekday) % 7 + toStart,
        );

  static const fromSigarraToDart = WeekdayMapper.fromStartWeekdays(
    fromStart: 1,
    fromStartWeekday: DateTime.sunday,
    toStart: 1,
    toStartWeekday: DateTime.monday,
  );

  final int _fromStart;
  final int _fromMonday;

  final int _toStart;
  final int _toMonday;

  WeekdayMapper then(WeekdayMapper other) {
    return WeekdayMapper(
      fromStart: _fromStart,
      fromMonday: _fromMonday,
      toStart: other._toStart,
      toMonday: other._toMonday,
    );
  }

  int map(int fromWeekday) {
    final mondayOffset = _toMonday - _fromMonday;

    // The algorithm is as follows:
    //
    // 1. Find the 0-based index of `fromWeekday` in the `from` system, by
    // subtracting `fromStart` from it. At this point, you're working with a
    // system that starts at 0 and ends at 6. You don't know which day is
    // Monday.
    // 2. Add the offset between the `from` and `to` Monday. Since we assume
    // that the `to` system starts at 0, we can simply add the difference
    // between the `from` and `to` Monday. This difference is `mondayOffset`.
    // By adding this positive difference, we're now working with a system that
    // is [mondayOffset, 6 + mondayOffset]. To go back to the 0-based system,
    // we take the modulo 7 of the day.
    // 3. At this point, we're working with a 0-based system that has been
    // shifted by `mondayOffset`. We can now add `toStart` to get the final
    // result.
    final fromWeekdayZeroBased = fromWeekday - _fromStart;
    final toWeekdayZeroBased = (fromWeekdayZeroBased + mondayOffset) % 7;
    final toWeekday = toWeekdayZeroBased + _toStart;

    return toWeekday;

    // In case you're wondering, like me, the compact formula is:
    // (fromWeekday - fromStart + toMonday - fromMonday) % 7 + toStart
  }
}
