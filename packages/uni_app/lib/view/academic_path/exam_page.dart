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
    /*
      If we want to filters exams again
        filteredExamTypes[Exam.getExamTypeLong(exam.examType)] ??
     */

    return LazyConsumer<ExamProvider, List<Exam>>(
      builder: (context, exams) => ListView(
        children: _examsByMonth(exams)
            .entries
            .map(
              (entry) => Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateTime(
                        int.parse(entry.key.split('-')[0]),
                        int.parse(entry.key.split('-')[1]),
                      )
                          .fullMonth(
                            Provider.of<LocaleNotifier>(context).getLocale(),
                          )
                          .capitalize(),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: entry.value.length,
                      prototypeItem: const TimelineItem(
                        title: '1',
                        subtitle: 'Jan',
                        card: ExamCard(
                          name: 'Computer Laboratory',
                          acronym: 'LCOM',
                          rooms: ['B315', 'B224', 'B207'],
                          type: 'MT',
                          startTime: '12:00',
                        ),
                      ),
                      itemBuilder: (context, index) {
                        final exam = entry.value[index];
                        return TimelineItem(
                          title: exam.start.day.toString(),
                          subtitle: exam.start
                              .shortMonth(
                                Provider.of<LocaleNotifier>(context)
                                    .getLocale(),
                              )
                              .capitalize(),
                          isActive: _nextExam(exams) == exam,
                          card: ExamCard(
                            name: exam.subject,
                            acronym: exam.subjectAcronym,
                            rooms: exam.rooms
                                .where((room) => room.isNotEmpty)
                                .toList(),
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

                                setState(() {
                                  PreferencesController.saveHiddenExams(
                                    hiddenExams,
                                  );
                                });
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
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
