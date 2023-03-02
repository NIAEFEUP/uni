import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';
import 'package:uni/view/common_widgets/random_image.dart';
import 'package:uni/view/exams/widgets/exam_page_title.dart';
import 'package:uni/view/common_widgets/row_container.dart';
import 'package:uni/view/exams/widgets/exam_row.dart';
import 'package:uni/view/exams/widgets/day_title.dart';

class ExamsPageView extends StatefulWidget {
  const ExamsPageView({super.key});

  @override
  State<StatefulWidget> createState() => ExamsPageViewState();
}

/// Tracks the state of `ExamsLists`.
class ExamsPageViewState extends GeneralPageViewState<ExamsPageView> {
  final double borderRadius = 10.0;

  @override
  Widget getBody(BuildContext context) {
    return StoreConnector<AppState, List<dynamic>?>(
      converter: (store) {
        final List<Exam> exams = store.state.content['exams'];
        final List<String> hiddenExams =
            store.state.content['hiddenExams'] ?? <String>[];
        for (var exam in exams) {
          exam.isHidden = hiddenExams.contains(exam.id);
        }
        final Map<String, bool> filteredExams =
            store.state.content['filteredExams'] ?? [];
        return exams
            .where((exam) =>
                filteredExams[Exam.getExamTypeLong(exam.type)] ?? true)
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
  List<Widget> createExamsColumn(context, List<Exam> exams) {
    final List<Widget> columns = <Widget>[];
    final List<String> images = ['assets/images/vacation.png', 'assets/images/swim_guy.png'];

    columns.add(const ExamPageTitle());

    if (exams.isEmpty) {
      columns.add(Center(
          heightFactor: 1.2,
          child: Column(
              children: <Widget> [
                RotatingImage(
                    imagePaths: images,
                    width: 250,
                    height: 250,
                ),
                  const Text('Não tens exames marcados',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color.fromARGB(255, 0x75, 0x17, 0x1e)),
                ),
                const Text('\nParece que estás de férias!',
                  style: TextStyle(fontSize: 15),
                ),
              ])
      ));
      return columns;
    }

    if (exams.length == 1) {
      columns.add(createExamCard(context, [exams[0]]));
      return columns;
    }

    final List<Exam> currentDayExams = <Exam>[];

    for (int i = 0; i < exams.length; i++) {
      if (i + 1 >= exams.length) {
        if (exams[i].begin.day == exams[i - 1].begin.day &&
            exams[i].begin.month == exams[i - 1].begin.month) {
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

  Widget createExamCard(context, exams) {
    final keyValue = exams.map((exam) => exam.toString()).join();
    return Container(
      key: Key(keyValue),
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      child: createExamsCards(context, exams),
    );
  }

  Widget createExamsCards(context, List<Exam> exams) {
    final List<Widget> examCards = <Widget>[];
    examCards.add(DayTitle(
        day: exams[0].begin.day.toString(),
        weekDay: exams[0].weekDay,
        month: exams[0].month));
    for (int i = 0; i < exams.length; i++) {
      examCards.add(createExamContext(context, exams[i]));
    }
    return Column(children: examCards);
  }

  Widget createExamContext(context, Exam exam) {
    final keyValue = '${exam.toString()}-exam';
    return Container(
        key: Key(keyValue),
        margin: const EdgeInsets.fromLTRB(12, 4, 12, 0),
        child: RowContainer(
            color: exam.isHighlighted()
                ? Theme.of(context).hintColor
                : Theme.of(context).scaffoldBackgroundColor,
            child: ExamRow(
              exam: exam,
              teacher: '',
              mainPage: false,
            )));
  }
}
