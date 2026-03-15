import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/controller/fetchers/schedule_fetcher/schedule_fetcher_new_api.dart';
import 'package:uni/model/entities/course_units/sheet.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/providers/riverpod/session_provider.dart';
import 'package:uni/view/academic_path/widgets/no_classes_widget.dart';
import 'package:uni/view/academic_path/widgets/schedule_page_shimmer.dart';
import 'package:uni/view/academic_path/widgets/schedule_page_view.dart';
import 'package:uni/view/widgets/pages_layouts/secondary/secondary.dart';

final professorLecturesProvider = FutureProvider.autoDispose
    .family<List<Lecture>, String>((ref, professorCode) async {
      final session = await ref.watch(sessionProvider.future);
      if (session == null) {
        return [];
      }
      return ScheduleFetcherNewApiProfessor(
        professorCode: professorCode,
      ).getLectures(session);
    });

class ProfessorSchedulePage extends ConsumerWidget {
  const ProfessorSchedulePage({super.key, required this.professor});

  final Professor professor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      child: _buildProfessorSchedule(context, ref),
    );
  }

  Widget _buildProfessorSchedule(BuildContext context, WidgetRef ref) {
    final asyncLectures = ref.watch(professorLecturesProvider(professor.code));
    final now = DateTime.now();
    return asyncLectures.when(
      loading: () => const ShimmerSchedulePage(),
      error: (_, _) => const Center(child: NoClassesWidget()),
      data: (allLectures) {
        final startOfWeek = _getStartOfWeek(now, allLectures);
        final endOfNextWeek = startOfWeek.add(const Duration(days: 14));
        final lectures = allLectures
            .where(
              (l) =>
                  l.startTime.isAfter(startOfWeek) &&
                  l.startTime.isBefore(endOfNextWeek),
            )
            .toList();
        if (lectures.isEmpty) {
          return const Center(child: NoClassesWidget());
        }
        return SchedulePageView(lectures, startOfWeek: startOfWeek, now: now);
      },
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

class ProfessorSchedulePageView extends ConsumerStatefulWidget {
  const ProfessorSchedulePageView(this.professor, {super.key});

  final Professor professor;

  @override
  ConsumerState<ProfessorSchedulePageView> createState() =>
      _ProfessorSchedulePageViewState();
}

class _ProfessorSchedulePageViewState
    extends SecondaryPageViewState<ProfessorSchedulePageView> {
  @override
  Future<void> onRefresh() async {
    ref.invalidate(professorLecturesProvider(widget.professor.code));
  }

  @override
  String? getTitle() => widget.professor.name;

  @override
  Widget getBody(BuildContext context) {
    return ProfessorSchedulePage(professor: widget.professor);
  }
}
