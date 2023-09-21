import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/model/providers/lazy/exam_provider.dart';
import 'package:uni/view/common_widgets/expanded_image_label.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';
import 'package:uni/view/common_widgets/row_container.dart';
import 'package:uni/view/exams/widgets/day_title.dart';
import 'package:uni/view/exams/widgets/exam_page_title.dart';
import 'package:uni/view/exams/widgets/exam_row.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni/view/locale_notifier.dart';

class ExamsPageView extends StatefulWidget {
  const ExamsPageView({super.key});

  @override
  State<StatefulWidget> createState() => ExamsPageViewState();
}

/// Tracks the state of `ExamsLists`.
class ExamsPageViewState extends GeneralPageViewState<ExamsPageView> {
  final double borderRadius = 10;

  @override
  Widget getBody(BuildContext context) {
    return LazyConsumer<ExamProvider>(
      builder: (context, examProvider) {
        return ListView(
          children: <Widget>[
            Column(
              children:
                  createExamsColumn(context, examProvider.getFilteredExams()),
            )
          ],
        );
      },
    );
  }

  /// Creates a column with all the user's exams.
  List<Widget> createExamsColumn(BuildContext context, List<Exam> exams) {
    final columns = <Widget>[const ExamPageTitle()];

    if (exams.isEmpty) {
      columns.add(
        Center(
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
      return columns;
    }

    if (exams.length == 1) {
      columns.add(createExamCard(context, [exams[0]]));
      return columns;
    }

    final currentDayExams = <Exam>[];

    for (var i = 0; i < exams.length; i++) {
      if (i + 1 >= exams.length) {
        if (exams[i].begin.day == exams[i - 1].begin.day &&
            exams[i].begin.month == exams[i - 1].begin.month) {
          currentDayExams.add(exams[i]);
        } else {
          if (currentDayExams.isNotEmpty) {
            columns.add(createExamCard(context, currentDayExams));
          }
          currentDayExams
            ..clear()
            ..add(exams[i]);
        }
        columns.add(createExamCard(context, currentDayExams));
        break;
      }
      if (exams[i].begin.day == exams[i + 1].begin.day &&
          exams[i].begin.month == exams[i + 1].begin.month) {
        currentDayExams.add(exams[i]);
      } else {
        currentDayExams.add(exams[i]);
        columns.add(createExamCard(context, currentDayExams));
        currentDayExams.clear();
      }
    }
    return columns;
  }

  Widget createExamCard(BuildContext context, List<Exam> exams) {
    final keyValue = exams.map((exam) => exam.toString()).join();
    return Container(
      key: Key(keyValue),
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      child: createExamsCards(context, exams),
    );
  }

  Widget createExamsCards(BuildContext context, List<Exam> exams) {
    final locale = Provider.of<LocaleNotifier>(context).getLocale();
    final examCards = <Widget>[
      DayTitle(
        day: exams[0].begin.day.toString(),
        weekDay: exams[0].weekDay(locale),
        month: exams[0].month(locale),
      ),
    ];
    for (var i = 0; i < exams.length; i++) {
      examCards.add(createExamContext(context, exams[i]));
    }
    return Column(children: examCards);
  }

  Widget createExamContext(BuildContext context, Exam exam) {
    final isHidden =
        Provider.of<ExamProvider>(context).hiddenExams.contains(exam.id);
    return Container(
      key: Key('$exam-exam'),
      margin: const EdgeInsets.fromLTRB(12, 4, 12, 0),
      child: RowContainer(
        color: isHidden
            ? Theme.of(context).hintColor
            : Theme.of(context).scaffoldBackgroundColor,
        child: ExamRow(exam: exam, teacher: '', mainPage: false),
      ),
    );
  }

  @override
  Future<void> onRefresh(BuildContext context) async {
    return Provider.of<ExamProvider>(context, listen: false)
        .forceRefresh(context);
  }
}
