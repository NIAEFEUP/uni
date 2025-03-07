import 'package:flutter/material.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/providers/lazy/lecture_provider.dart';
import 'package:uni/view/academic_path/widgets/no_classes_widget.dart';
import 'package:uni/view/academic_path/widgets/schedule_page_view.dart';
import 'package:uni/view/lazy_consumer.dart';

class SchedulePage extends StatelessWidget {
  SchedulePage({super.key, DateTime? now}) : now = now ?? DateTime.now();

  final DateTime now;

  @override
  Widget build(BuildContext context) {
    const bottomNavbarHeight = 120.0;

    return LazyConsumer<LectureProvider, List<Lecture>>(
      builder: (context, lectures) {
        final startOfWeek = _getStartOfWeek(now, lectures);

        return SchedulePageView(
          lectures,
          startOfWeek: startOfWeek,
          now: now,
        );
      },
      hasContent: (lectures) => lectures.isNotEmpty,
      onNullContent: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            height: constraints.maxHeight,
            padding: const EdgeInsets.only(bottom: bottomNavbarHeight),
            child: const Center(
              child: NoClassesWidget(),
            ),
          ),
        ),
      ),
      mapper: (lectures) {
        final startOfWeek = _getStartOfWeek(now, lectures);
        final endOfNextWeek = startOfWeek.add(const Duration(days: 14));

        return lectures
            .where(
              (lecture) =>
                  lecture.startTime.isAfter(startOfWeek) &&
                  lecture.startTime.isBefore(endOfNextWeek),
            )
            .toList();
      },
    );
  }

  DateTime _getStartOfWeek(DateTime now, List<Lecture> lectures) {
    final initialSunday = now.subtract(Duration(days: now.weekday % 7));
    final secondSunday = initialSunday.add(const Duration(days: 7));

    final hasLecturesThisWeek = lectures.any(
      (lecture) =>
          lecture.startTime.isAfter(now) &&
          lecture.startTime.isBefore(secondSunday),
    );

    return !hasLecturesThisWeek ? secondSunday : initialSunday;
  }
}
