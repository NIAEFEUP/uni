import 'package:flutter/material.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/providers/riverpod/default_consumer.dart';
import 'package:uni/model/providers/riverpod/lecture_provider.dart';
import 'package:uni/view/academic_path/widgets/no_classes_widget.dart';
import 'package:uni/view/academic_path/widgets/schedule_page_view.dart';

class SchedulePage extends StatelessWidget {
  SchedulePage({super.key, DateTime? now}) : now = now ?? DateTime.now();

  final DateTime now;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      child: DefaultConsumer<List<Lecture>>(
        provider: lectureProvider,
        builder: (context, ref, lectures) {
          final startOfWeek = _getStartOfWeek(now, lectures);

          return SchedulePageView(lectures, startOfWeek: startOfWeek, now: now);
        },
        nullContentWidget: LayoutBuilder(
          builder:
              (context, constraints) => SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: constraints.maxHeight,
                  child: const Center(child: NoClassesWidget()),
                ),
              ),
        ),
        hasContent: (lectures) => lectures.isNotEmpty,
      ),
    );

    //     mapper: (lectures) {
    //       final startOfWeek = _getStartOfWeek(now, lectures);
    //       final endOfNextWeek = startOfWeek.add(const Duration(days: 14));

    //       return lectures
    //           .where(
    //             (lecture) =>
    //                 lecture.startTime.isAfter(startOfWeek) &&
    //                 lecture.startTime.isBefore(endOfNextWeek),
    //           )
    //           .toList();
    //     },
    //   ),
    // );
  }

  DateTime _getStartOfWeek(DateTime now, List<Lecture> lectures) {
    final initialSunday = now.subtract(Duration(days: now.weekday % 7));
    final secondSunday = initialSunday.add(const Duration(days: 7));

    final hasLecturesThisWeek = lectures.any(
      (lecture) =>
          lecture.endTime.isAfter(now) &&
          lecture.startTime.isBefore(secondSunday),
    );

    return !hasLecturesThisWeek ? secondSunday : initialSunday;
  }
}
