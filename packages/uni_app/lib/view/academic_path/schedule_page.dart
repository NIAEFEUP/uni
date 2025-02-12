import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/providers/lazy/lecture_provider.dart';
import 'package:uni/view/academic_path/widgets/empty_week.dart';
import 'package:uni/view/academic_path/widgets/schedule_page_view.dart';
import 'package:uni/view/lazy_consumer.dart';

class SchedulePage extends StatelessWidget {
  SchedulePage({super.key, DateTime? now}) : now = now ?? DateTime.now();

  final DateTime now;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      child: RefreshIndicator(
        onRefresh: () async {
          await context.read<LectureProvider>().forceRefresh(context);
        },
        child: LazyConsumer<LectureProvider, List<Lecture>>(
          builder: (context, lectures) {
            return SchedulePageView(
              lectures,
              now: now,
            );
          },
          hasContent: (lectures) => lectures.isNotEmpty,
          onNullContent: const EmptyWeek(),
        ),
      ),
    );
  }
}
