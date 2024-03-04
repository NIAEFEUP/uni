import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/utils/date_time_formatter.dart';
import 'package:uni/view/common_widgets/row_container.dart';
import 'package:uni/view/exams/widgets/exam_title.dart';
import 'package:uni/view/locale_notifier.dart';

class RemainingExamsWidget extends StatelessWidget {
  const RemainingExamsWidget({required this.exams, super.key});

  final List<Exam> exams;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: exams.map((exam) {
        final locale = Provider.of<LocaleNotifier>(context).getLocale();
        return Container(
          margin: const EdgeInsets.only(top: 8),
          child: RowContainer(
            color: Theme.of(context).colorScheme.background,
            child: Container(
              padding: const EdgeInsets.all(11),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    exam.begin.formattedDate(locale),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  ExamTitle(
                    subject: exam.subject,
                    type: exam.type,
                    reverseOrder: true,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
