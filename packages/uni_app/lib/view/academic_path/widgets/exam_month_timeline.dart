import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uni/model/entities/app_locale.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/view/academic_path/widgets/exam_modal.dart';
import 'package:uni/view/locale_notifier.dart';
import 'package:uni_ui/cards/exam_card.dart';
import 'package:uni_ui/cards/timeline_card.dart';

class ExamMonthTimeline extends ConsumerWidget {
  const ExamMonthTimeline({
    super.key,
    required this.now,
    required this.monthDate,
    required this.exams,
    this.hiddenExams,
    this.onToggleHidden,
  });

  final DateTime now;
  final DateTime monthDate;
  final List<Exam> exams;
  final List<String>? hiddenExams;
  final void Function(String)? onToggleHidden;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocale = ref.watch(localeProvider.select((value) => value));

    if (exams.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat(
              'MMMM yyyy',
              appLocale.localeCode.languageCode,
            ).format(monthDate),
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 14),
          CardTimeline(
            items: _buildTimelineItems(exams, context, ref, appLocale),
          ),
        ],
      ),
    );
  }

  List<TimelineItem> _buildTimelineItems(
    List<Exam> exams,
    BuildContext context,
    WidgetRef ref,
    AppLocale appLocale,
  ) {
    final groups = _groupExamsByDay(exams);

    return groups.map((group) {
      final isActive = group.any(_isExamActive);
      final firstExam = group.first;

      return TimelineItem(
        isActive: isActive,
        title: firstExam.start.day.toString(),
        subtitle: firstExam.monthAcronym(appLocale),
        lineHeight: 55 + 13 * (group.length - 1) + 78 * (group.length - 1),
        card: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: group.map((exam) {
            return ExamCard(
              name: exam.subject,
              acronym: exam.subjectAcronym,
              rooms: exam.rooms,
              type: exam.examType,
              startTime: exam.formatTime(exam.start),
              isInvisible: hiddenExams?.contains(exam.id) ?? false,
              onClick: () {
                showDialog<void>(
                  context: context,
                  builder: (context) => ExamModal(exam: exam),
                );
              },
              iconAction: onToggleHidden == null
                  ? null
                  : () => onToggleHidden!(exam.id),
            );
          }).toList(),
        ),
      );
    }).toList();
  }

  List<List<Exam>> _groupExamsByDay(List<Exam> exams) {
    final sorted = [...exams]..sort((a, b) => a.start.compareTo(b.start));

    final groups = <List<Exam>>[];
    var currentGroup = [sorted.first];
    var currentDay = sorted.first.start.day;

    for (final exam in sorted.skip(1)) {
      if (exam.start.day == currentDay) {
        currentGroup.add(exam);
      } else {
        groups.add(currentGroup);
        currentGroup = [exam];
        currentDay = exam.start.day;
      }
    }
    groups.add(currentGroup);

    return groups;
  }

  bool _isExamActive(Exam exam) {
    return now.isAfter(exam.start) && now.isBefore(exam.finish);
  }
}
