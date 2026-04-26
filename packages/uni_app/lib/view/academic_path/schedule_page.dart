import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/providers/riverpod/default_consumer.dart';
import 'package:uni/model/providers/riverpod/lecture_provider.dart';
import 'package:uni/view/academic_path/widgets/schedule_page_shimmer.dart';
import 'package:uni/view/academic_path/widgets/schedule_page_view.dart';
import 'package:uni_ui/common_widgets/empty_state_widget.dart';

class SchedulePage extends ConsumerWidget {
  SchedulePage({super.key, DateTime? now}) : now = now ?? DateTime.now();

  final DateTime now;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          builder: (context, constraints) => SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              height: constraints.maxHeight,
              padding: const EdgeInsets.only(bottom: 120),
              child: Center(
                child: EmptyStateWidget(
                  imagePath: 'assets/images/school.png',
                  title: S.of(context).no_classes,
                  subtitle: S.of(context).no_classes_this_week,
                ),
              ),
            ),
          ),
        ),
        hasContent: (lectures) => lectures.isNotEmpty,
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
        loadingWidget: const ShimmerSchedulePage(),
      ),
    );
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
