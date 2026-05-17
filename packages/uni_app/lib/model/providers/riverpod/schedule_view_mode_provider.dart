import 'package:flutter_riverpod/legacy.dart';

enum ScheduleViewMode {
  list,
  calendar,
}

final StateProvider<ScheduleViewMode> scheduleViewModeProvider =
    StateProvider<ScheduleViewMode>((ref) => ScheduleViewMode.list);
