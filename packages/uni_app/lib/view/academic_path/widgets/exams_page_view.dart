import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/utils/date_time_formatter.dart';
import 'package:uni/view/academic_path/widgets/exam_month_timeline.dart';
import 'package:uni/view/locale_notifier.dart';
import 'package:uni_ui/timeline/timeline.dart';

class ExamsPageView extends ConsumerWidget {
  const ExamsPageView({
    super.key,
    required this.exams,
    required this.hiddenExams,
    required this.onToggleHidden,
  });

  final List<Exam> exams;
  final List<String> hiddenExams;
  final void Function(String) onToggleHidden;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider.select((value) => value));

    final examsByMonth = _examsByMonth(exams);
    final now = DateTime.now();
    final currentYear = now.year;
    final hasNextYearExams = exams.any((e) => e.start.year > currentYear);
    final years = <int>[currentYear];
    if (hasNextYearExams) {
      years.add(currentYear + 1);
    }

    final monthsDates =
        years
            .expand((y) => List.generate(12, (index) => DateTime(y, index + 1)))
            .toList();

    final tabs =
        monthsDates.map((date) {
          return SizedBox(
            width: 30,
            height: 34,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    date.shortMonth(locale),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  ),
                ),
                Expanded(
                  child: Text(
                    '${date.month}',
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          );
        }).toList();

    final content =
        monthsDates.map((date) {
          final monthKey = '${date.year}-${date.month}';
          final examsForMonth = examsByMonth[monthKey] ?? [];
          return ExamMonthTimeline(
            now: now,
            monthDate: date,
            exams: examsForMonth,
            hiddenExams: hiddenExams,
            onToggleHidden: onToggleHidden,
          );
        }).toList();

    final initialTabIndex = monthsDates.indexWhere((date) {
      final monthKey = '${date.year}-${date.month}';
      return examsByMonth.containsKey(monthKey);
    });

    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
      child: Timeline(
        tabs: tabs,
        content: content,
        initialTab: initialTabIndex == -1 ? 0 : initialTabIndex,
        tabEnabled:
            monthsDates
                .map(
                  (date) =>
                      examsByMonth.containsKey('${date.year}-${date.month}'),
                )
                .toList(),
      ),
    );
  }

  Map<String, List<Exam>> _examsByMonth(List<Exam> exams) {
    final months = <String, List<Exam>>{};
    for (final exam in exams) {
      final month = '${exam.start.year}-${exam.start.month}';
      months.putIfAbsent(month, () => []).add(exam);
    }
    return months;
  }
}
