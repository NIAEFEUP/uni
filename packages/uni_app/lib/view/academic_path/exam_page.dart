import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/model/providers/lazy/exam_provider.dart';
import 'package:uni/utils/date_time_formatter.dart';
import 'package:uni/utils/string_formatter.dart';
import 'package:uni/view/common_widgets/expanded_image_label.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni/view/locale_notifier.dart';
import 'package:uni_ui/cards/exam_card.dart';
import 'package:uni_ui/cards/timeline_card.dart';
import 'package:uni_ui/theme.dart';
import 'package:uni_ui/timeline/timeline.dart';

class ExamsPage extends StatefulWidget {
  const ExamsPage({super.key});

  @override
  State<StatefulWidget> createState() => _ExamsPageState();
}

class _ExamsPageState extends State<ExamsPage> {
  List<String> hiddenExams = PreferencesController.getHiddenExams();
  Map<String, bool> filteredExamTypes =
      PreferencesController.getFilteredExams();

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      child: LazyConsumer<ExamProvider, List<Exam>>(
        builder: (context, exams) {
          // Mock exams for testing
          exams = [
            Exam(
              '1',
              DateTime.now().add(Duration(days: 5)),
              DateTime.now().add(Duration(days: 5, hours: 2)),
              'LCOM',
              'Computer Laboratory',
              ['B315', 'B316'],
              'MT',
              'FEUP',
            ),
            Exam(
              '2',
              DateTime.now().add(Duration(days: 10)),
              DateTime.now().add(Duration(days: 10, hours: 2)),
              'ES',
              'Software Engineering',
              ['B102'],
              'EN',
              'FEUP',
            ),
            Exam(
              '3',
              DateTime.now().add(Duration(days: 15)),
              DateTime.now().add(Duration(days: 15, hours: 2)),
              'ME',
              'Statistical Methods',
              ['B103'],
              'EN',
              'FEUP',
            ),
            Exam(
              '4',
              DateTime.now().add(Duration(days: 20)),
              DateTime.now().add(Duration(days: 20, hours: 2)),
              'LTW',
              'Web Languages and Technologies',
              ['B104'],
              'ER',
              'FEUP',
            ),
          ];

          final examsByMonth = _examsByMonth(exams);
          final tabs = exams.map((exam) {
            return Column(
              children: [
                Text(
                  exam.start.shortMonth(
                    Provider.of<LocaleNotifier>(context).getLocale(),
                  ),
                  style: lightTheme.textTheme.bodySmall,
                ),
                Text(
                  '${exam.start.day}',
                  style: lightTheme.textTheme.bodySmall,
                ),
              ],
            );
          }).toList();
          final content = examsByMonth.entries.map((entry) {
            final month = entry.key;
            final exams = entry.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    DateTime(
                      int.parse(month.split('-')[0]),
                      int.parse(month.split('-')[1]),
                    )
                        .fullMonth(
                          Provider.of<LocaleNotifier>(context).getLocale(),
                        )
                        .capitalize(),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: exams.length,
                  itemBuilder: (context, index) {
                    final exam = exams[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: TimelineItem(
                        title: exam.start.day.toString(),
                        subtitle: exam.start
                            .shortMonth(
                              Provider.of<LocaleNotifier>(context).getLocale(),
                            )
                            .capitalize(),
                        isActive: _nextExam(exams) == exam,
                        card: ExamCard(
                          name: exam.subject,
                          acronym: exam.subjectAcronym,
                          rooms: exam.rooms,
                          type: exam.examType,
                          startTime: exam.formatTime(exam.start),
                          isInvisible: hiddenExams.contains(exam.id),
                          iconAction: () {
                            setState(() {
                              if (hiddenExams.contains(exam.id)) {
                                hiddenExams.remove(exam.id);
                              } else {
                                hiddenExams.add(exam.id);
                              }
                              PreferencesController.saveHiddenExams(
                                  hiddenExams);
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          }).toList();

          return Column(
            children: [
              Expanded(child: Timeline(tabs: tabs, content: content)),
            ],
          );
        },
        hasContent: (exams) => exams.isNotEmpty,
        onNullContent: Center(
          heightFactor: 1.2,
          child: ImageLabel(
            imagePath: 'assets/images/vacation.png',
            label: S.of(context).no_exams_label,
            labelTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Theme.of(context).colorScheme.primary,
            ),
            sublabel: S.of(context).no_exams,
            sublabelTextStyle: const TextStyle(fontSize: 15),
          ),
        ),
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

  Exam? _nextExam(List<Exam> exams) {
    final now = DateTime.now();
    final nextExams = exams.where((exam) => exam.start.isAfter(now)).toList()
      ..sort((a, b) => a.start.compareTo(b.start));
    return nextExams.isNotEmpty ? nextExams.first : null;
  }

  /*
  @override
  Widget? getTopRightButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ExamFilterButton(
        () => setState(() {
          filteredExamTypes = PreferencesController.getFilteredExams();
        }),
      ),
    );
  }
  */
}
