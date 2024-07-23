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

  static const fromDartToIndex = WeekdayMapper.fromStartWeekdays(
    fromStart: 1,
    fromStartWeekday: DateTime.monday,
    toStart: 0,
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

  WeekdayMapper get inverse => WeekdayMapper(
        fromStart: _toStart,
        fromMonday: _toMonday,
        toStart: _fromStart,
        toMonday: _fromMonday,
      );

  int map(int fromWeekday) {
    // To find the resulting weekday, it goes like this:
    //
    // 1. The resulting weekday will be `toWeekdayZeroBased + toStart`.
    // `toWeekdayZeroBased` corresponds to the resulting weekday in a system
    // that is [0, 6]. By adding `toStart`, we are mapping it to the `to`
    // system.
    //
    // 2. The `toWeekdayZeroBased` will be `toWeekdayZeroBasedUnbound % 7`.
    // This operation is essential to return a value that is bound within the
    // 7 weekdays that a week has.
    //
    // 3. The `toWeekdayZeroBasedUnbound` will be
    // `fromWeekdayZeroBased + mondayIndexOffset`. `fromWeekdayZeroBased`
    // corresponds to the provided weekday in a system that is [0, 6]. This
    // can be obtained by performing the operation `fromWeekday - fromStart`.
    //
    // 4. `mondayIndexOffset` corresponds to the number of days that we need
    // to advance a monday (or any other day) in the `from` system to get the
    // corresponding weekday in the `to` system. This can be obtained by taking
    // difference between `toMondayZeroBased` and `fromMondayZeroBased`. These
    // two values can be obtained in the same fashion as `fromWeekdayZeroBased`.
    //
    // Taking these steps into account, we can derive the following formula:
    //
    // 1. toWeekdayZeroBased + toStart
    // 2. toWeekdayZeroBasedUnbound % 7 + toStart
    // 3. (fromWeekdayZeroBased + mondayIndexOffset) % 7 + toStart
    // 4. (fromWeekday - fromStart + mondayIndexOffset) % 7 + toStart
    // 5. (fromWeekday - fromStart
    //  + toMondayZeroBased - fromMondayZeroBased) % 7 + toStart
    // 6. (fromWeekday - fromStart
    //  + (toMonday - toStart) - fromMondayZeroBased) % 7 + toStart
    // 7. (fromWeekday - fromStart
    //  + (toMonday - toStart) - (fromMonday - fromStart)) % 7 + toStart
    // 8. (fromWeekday - fromStart
    //  + (toMonday - toStart) - (fromMonday - fromStart)) % 7 + toStart
    // 9. (fromWeekday - fromStart
    //  + toMonday - toStart - fromMonday + fromStart) % 7 + toStart
    // 10. (fromWeekday + toMonday - toStart - fromMonday) % 7 + toStart
    final toWeekdayZeroBased =
        (fromWeekday + _toMonday - _toStart - _fromMonday) % 7;
    final toWeekday = toWeekdayZeroBased + _toStart;

    return toWeekday;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is WeekdayMapper &&
        other._fromStart == _fromStart &&
        other._fromMonday == _fromMonday &&
        other._toStart == _toStart &&
        other._toMonday == _toMonday;
  }

  @override
  int get hashCode =>
      _fromStart.hashCode ^
      _fromMonday.hashCode ^
      _toStart.hashCode ^
      _toMonday.hashCode;

  @override
  String toString() => 'WeekdayMapper(fromStart: $_fromStart, '
      'fromMonday: $_fromMonday, toStart: $_toStart, toMonday: $_toMonday)';
}
