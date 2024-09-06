import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/utils/date_time_formatter.dart';
import 'package:uni/view/common_widgets/date_rectangle.dart';
import 'package:uni/view/common_widgets/row_container.dart';
import 'package:uni/view/exams/widgets/exam_row.dart';
import 'package:uni/view/locale_notifier.dart';

class NextExamsWidget extends StatelessWidget {
  const NextExamsWidget({required this.exams, super.key});

  final List<Exam> exams;

  @override
  Widget build(BuildContext context) {
    final locale = Provider.of<LocaleNotifier>(context).getLocale();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DateRectangle(
          date: exams.isNotEmpty ? exams.first.start.formattedDate(locale) : '',
        ),
        Column(
          children: exams.map((exam) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: RowContainer(
                child: ExamRow(
                  exam: exam,
                  teacher: '',
                  mainPage: true,
                  onChangeVisibility: () {},
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
