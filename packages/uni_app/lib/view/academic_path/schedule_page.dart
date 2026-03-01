import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/providers/riverpod/default_consumer.dart';
import 'package:uni/model/providers/riverpod/lecture_provider.dart';
import 'package:uni/view/academic_path/widgets/no_classes_widget.dart';
import 'package:uni/view/academic_path/widgets/schedule_page_shimmer.dart';
import 'package:uni/view/academic_path/widgets/schedule_page_view.dart';

class SchedulePage extends ConsumerStatefulWidget {
  SchedulePage({super.key, DateTime? now}) : now = now ?? DateTime.now();

  final DateTime now;

  @override
  ConsumerState<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends ConsumerState<SchedulePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      child: DefaultConsumer<List<Lecture>>(
        provider: lectureProvider,
        builder: (context, ref, lectures) {
          final startOfWeek = _getStartOfWeek(widget.now, lectures);

          return SchedulePageView(
            lectures,
            startOfWeek: startOfWeek,
            now: widget.now,
          );
        },
        nullContentWidget: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              height: constraints.maxHeight,
              padding: const EdgeInsets.only(bottom: 120),
              child: const Center(child: NoClassesWidget()),
            ),
          ),
        ),
        hasContent: (lectures) => lectures.isNotEmpty,
        mapper: (lectures) {
          final startOfWeek = _getStartOfWeek(widget.now, lectures);
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
