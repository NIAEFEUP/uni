import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/controller/exam.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/view/PagesLayouts/Secondary/secondary.dart';
import 'package:uni/view/Pages/Exams/widgets/exam_page_title_filter.dart';
import 'package:uni/view/Common/row_container.dart';
import 'package:uni/view/Pages/Exams/widgets/schedule_row.dart';
import 'package:uni/view/Pages/Exams/widgets/title_card.dart';

class ExamsPageView extends StatefulWidget {
  const ExamsPageView({super.key});

  @override
  State<StatefulWidget> createState() => ExamsPageViewState();
}

/// Tracks the state of `ExamsLists`.
class ExamsPageViewState extends SecondaryPageViewState<ExamsPageView> {
  final double borderRadius = 10.0;

  @override
  Widget getBody(BuildContext context) {
    return StoreConnector<AppState, List<dynamic>?>(
      converter: (store) {
        final List<Exam> exams = store.state.content['exams'];
        final Map<String, bool> filteredExams =
            store.state.content['filteredExams'] ?? [];
        return exams
            .where((exam) =>
                filteredExams[Exam.getExamTypeLong(exam.examType)] ?? true)
            .toList();
      },
      builder: (context, exams) {
        return ExamsList(exams: exams as List<Exam>);
      },
    );
  }
}

/// Manages the 'Exams' section in the user's personal area and 'Exams Map'.
class ExamsList extends StatelessWidget {
  final List<Exam> exams;

  const ExamsList({Key? key, required this.exams}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.max,
          children: createExamsColumn(context, exams),
        )
      ],
    );
  }

  /// Creates a column with all the user's exams.
  List<Widget> createExamsColumn(context, exams) {
    final List<Widget> columns = <Widget>[];
    columns.add(const ExamPageTitleFilter(
      name: 'Exames',
    ));

    if (exams.length == 1) {
      columns.add(createExamCard(context, [exams[0]]));
      return columns;
    }

    final List<Exam> currentDayExams = <Exam>[];

    for (int i = 0; i < exams.length; i++) {
      if (i + 1 >= exams.length) {
        if (exams[i].day == exams[i - 1].day &&
            exams[i].month == exams[i - 1].month) {
          currentDayExams.add(exams[i]);
        } else {
          if (currentDayExams.isNotEmpty) {
            columns.add(createExamCard(context, currentDayExams));
          }
          currentDayExams.clear();
          currentDayExams.add(exams[i]);
        }
        columns.add(createExamCard(context, currentDayExams));
        break;
      }
      if (exams[i].day == exams[i + 1].day &&
          exams[i].month == exams[i + 1].month) {
        currentDayExams.add(exams[i]);
      } else {
        currentDayExams.add(exams[i]);
        columns.add(createExamCard(context, currentDayExams));
        currentDayExams.clear();
      }
    }
    return columns;
  }

  Widget createExamCard(context, exams) {
    final keyValue = exams.map((exam) => exam.toString()).join();
    return Container(
      key: Key(keyValue),
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      child: createExamsCards(context, exams),
    );
  }

  Widget createExamsCards(context, exams) {
    final List<Widget> examCards = <Widget>[];
    examCards.add(TitleCard(
        day: exams[0].day, weekDay: exams[0].weekDay, month: exams[0].month));
    for (int i = 0; i < exams.length; i++) {
      examCards.add(createExamContext(context, exams[i]));
    }
    return Column(children: examCards);
  }

  Widget createExamContext(context, exam) {
    final keyValue = '${exam.toString()}-exam';
    return Container(
        key: Key(keyValue),
        margin: const EdgeInsets.fromLTRB(12, 4, 12, 0),
        child: RowContainer(
            color: isHighlighted(exam)
                ? Theme.of(context).hintColor
                : Theme.of(context).scaffoldBackgroundColor,
            child: ScheduleRow(
              subject: exam.subject,
              rooms: exam.rooms,
              begin: exam.begin,
              end: exam.end,
              type: exam.examType,
              date: exam.date,
              teacher: '',
            )));
  }
}
