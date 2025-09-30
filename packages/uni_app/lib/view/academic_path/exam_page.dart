import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/model/providers/riverpod/default_consumer.dart';
import 'package:uni/model/providers/riverpod/exam_provider.dart';
import 'package:uni/utils/date_time_formatter.dart';
import 'package:uni/utils/string_formatter.dart';
import 'package:uni/view/academic_path/widgets/exam_modal.dart';
import 'package:uni/view/academic_path/widgets/no_exams_widget.dart';
import 'package:uni/view/locale_notifier.dart';
import 'package:uni_ui/cards/exam_card.dart';
import 'package:uni_ui/cards/timeline_card.dart';
import 'package:uni_ui/timeline/timeline.dart';

class ExamsPage extends ConsumerStatefulWidget {
  const ExamsPage({super.key});

  @override
  ConsumerState<ExamsPage> createState() => _ExamsPageState();
}

class _ExamsPageState extends ConsumerState<ExamsPage> {
  List<String> hiddenExams = PreferencesController.getHiddenExams();
  Map<String, bool> filteredExamTypes =
      PreferencesController.getFilteredExams();

  @override
  Widget build(BuildContext context) {
    /*
      If we want to filters exams again
        filteredExamTypes[Exam.getExamTypeLong(exam.examType)] ??
     */
    return MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      child: DefaultConsumer<List<Exam>>(
        provider: examProvider,
        builder: (context, ref, exams) {
          final locale = ref.watch(localeProvider.select((value) => value));

          final examsByMonth = _examsByMonth(exams);
          final allMonths = List.generate(12, (index) => index + 1);
          final tabs =
              allMonths.map((month) {
                final date = DateTime(DateTime.now().year, month);
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
              allMonths.map((month) {
                final monthKey = '${DateTime.now().year}-$month';
                final exams = examsByMonth[monthKey] ?? [];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (exams.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          DateTime(
                            DateTime.now().year,
                            month,
                          ).fullMonth(locale).capitalize(),
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                      ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: exams.length,
                      itemBuilder: (context, index) {
                        final exam = exams[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4, top: 4),
                          child: TimelineItem(
                            title: exam.start.day.toString(),
                            subtitle:
                                exam.start.shortMonth(locale).capitalize(),
                            // isActive: _nextExam(exams) == exam, //TODO: Emphasize next exam together with the exam card.
                            card: ExamCard(
                              name: exam.subject,
                              acronym: exam.subjectAcronym,
                              rooms: exam.rooms,
                              type: exam.examType,
                              startTime: exam.formatTime(exam.start),
                              isInvisible: hiddenExams.contains(exam.id),
                              onClick: () {
                                showDialog<void>(
                                  context: context,
                                  builder: (context) => ExamModal(exam: exam),
                                );
                              },
                              iconAction: () {
                                setState(() {
                                  if (hiddenExams.contains(exam.id)) {
                                    hiddenExams.remove(exam.id);
                                  } else {
                                    hiddenExams.add(exam.id);
                                  }
                                  PreferencesController.saveHiddenExams(
                                    hiddenExams,
                                  );
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
          return Timeline(
            tabs: tabs,
            content: content,
            initialTab: allMonths.indexWhere((month) {
              final monthKey = '${DateTime.now().year}-$month';
              return examsByMonth.containsKey(monthKey);
            }),
            tabEnabled:
                allMonths.map((month) {
                  final monthKey = '${DateTime.now().year}-$month';
                  return examsByMonth.containsKey(monthKey);
                }).toList(),
          );
        },
        hasContent: (exams) => exams.isNotEmpty,
        nullContentWidget: LayoutBuilder(
          // Band-aid for allowing refresh on null content
          builder:
              (context, constraints) => SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: constraints.maxHeight, // Height of bottom navbar
                  child: const Center(child: NoExamsWidget()),
                ),
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
}
