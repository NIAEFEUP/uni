import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:uni/generated/l10n.dart';

part '../../generated/model/entities/calendar_event.g.dart';

@JsonSerializable()
@Entity()
class CalendarEvent {
  CalendarEvent({required this.name, this.startDate, this.endDate});
  factory CalendarEvent.fromJson(Map<String, dynamic> json) =>
      _$CalendarEventFromJson(json);
  String name;

  @JsonKey(name: 'start_date')
  DateTime? startDate;

  @JsonKey(name: 'end_date')
  DateTime? endDate;

  @Id()
  int? uniqueId;

  /// Formats the event's date range into a two-part list: [dateRange, year].
  /// Returns ['TBD', ''] if startDate is null.
  List<String> get formattedPeriod {
    if (startDate == null && endDate == null) {
      return ['TBD', ''];
    }

    if (startDate == null && endDate != null) {
      final monthFormatter = DateFormat.MMM('pt');
      final day = endDate!.day.toString();
      final month = monthFormatter.format(endDate!);
      return ['${S.current.until} $day $month', endDate!.year.toString()];
    }

    final monthFormatter = DateFormat.MMM('pt');
    final period = <String>[];
    String timePeriod;

    final year = startDate!.year.toString();
    final month = monthFormatter.format(startDate!);
    final day = startDate!.day.toString();

    if (endDate == null || startDate == endDate) {
      timePeriod = '$day $month';
      period
        ..add(timePeriod)
        ..add(year);
      return period;
    }

    final dayEnd = endDate!.day.toString();
    final yearEnd = endDate!.year.toString();
    final monthEnd = monthFormatter.format(endDate!);

    if (year == yearEnd) {
      if (month == monthEnd) {
        timePeriod = '$day-$dayEnd $month'; // e.g., 1-5 Fev
      } else {
        timePeriod = '$day $month - $dayEnd $monthEnd'; // e.g., 30 Jan - 5 Fev
      }
      period
        ..add(timePeriod)
        ..add(year);
    } else {
      timePeriod =
          '$day $month  - $dayEnd $monthEnd'; // e.g., 30 Jan 2023 - 5 Fev 2024

      period
        ..add(timePeriod)
        ..add('$year - $yearEnd');
    }
    return period;
  }

  Map<String, dynamic> toJson() => _$CalendarEventToJson(this);
}
