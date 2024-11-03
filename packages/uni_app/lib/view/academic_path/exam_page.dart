import 'package:flutter/material.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/model/providers/lazy/exam_provider.dart';
import 'package:uni/view/common_widgets/expanded_image_label.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni_ui/cards/exam_card.dart';
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
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    /*
      If we want to filters exams again
        filteredExamTypes[Exam.getExamTypeLong(exam.examType)] ??
     */

    return LazyConsumer<ExamProvider, List<Exam>>(
      builder: (context, exams) => Timeline(
        tabs: _examsByMonth(exams)
            .keys
            .map(
              (key) => Column(
                children: [
                  Text(months[int.parse(key.split('-')[1]) - 1]),
                  Text(key.split('-')[1]),
                ],
              ),
            )
            .toList(),
        content: _examsByMonth(exams)
            .entries
            .map(
              (entry) => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: entry.value.length,
                prototypeItem: const ExamCard(
                  //TODO(thePeras): Solve this at parser level
                  name: 'Computer Laboratory',
                  acronym: 'LCOM',
                  rooms: ['B315', 'B224', 'B207'],
                  type: 'MT',
                  startTime: '12:00',
                ),
                itemBuilder: (context, index) {
                  final exam = entry.value[index];
                  return ExamCard(
                    name: 'Subject Name',
                    acronym: exam.subject,
                    //TODO(thePeras): Solve this at parser level
                    rooms: exam.rooms.where((room) => room.isNotEmpty).toList(),
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
                  );
                },
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
