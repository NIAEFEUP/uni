import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/providers/riverpod/schedule_view_mode_provider.dart';
import 'package:uni/model/utils/time/week.dart';
import 'package:uni/view/academic_path/widgets/schedule_calendar_view.dart';
import 'package:uni/view/academic_path/widgets/schedule_list_view.dart';

class SchedulePageView extends ConsumerWidget {
  SchedulePageView(
    this.lectures, {
    required this.now,
    required DateTime startOfWeek,
    this.showClassNumber = false,
    super.key,
  }) : currentWeek = Week(start: startOfWeek);

  final DateTime now;
  final List<Lecture> lectures;
  final Week currentWeek;
  final bool showClassNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ScheduleViewMode selectedView = ref.watch<ScheduleViewMode>(
      scheduleViewModeProvider,
    );

    return selectedView == ScheduleViewMode.list
        ? ScheduleListView(
            lectures: lectures,
            now: now,
            currentWeek: currentWeek,
            showClassNumber: showClassNumber,
          )
        : ScheduleCalendarView(
            lectures,
            startOfWeek: currentWeek.start,
            now: now,
          );
  }
}
