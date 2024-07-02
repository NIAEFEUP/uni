import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/model/providers/lazy/exam_provider.dart';
import 'package:uni/utils/date_time_formatter.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/common_widgets/expanded_image_label.dart';
import 'package:uni/view/common_widgets/pages_layouts/secondary/secondary.dart';
import 'package:uni/view/common_widgets/row_container.dart';
import 'package:uni/view/exams/widgets/exam_filter_button.dart';
import 'package:uni/view/exams/widgets/exam_row.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni/view/locale_notifier.dart';

class ExamsPageView extends StatefulWidget {
  const ExamsPageView({super.key});

  @override
  State<StatefulWidget> createState() => ExamsPageViewState();
}

class ExamsPageViewState extends SecondaryPageViewState<ExamsPageView> {
  List<String> hiddenExams = PreferencesController.getHiddenExams();
  Map<String, bool> filteredExamTypes =
      PreferencesController.getFilteredExams();

  @override
  Widget getBody(BuildContext context) {
    return ListView(
      children: [
        LazyConsumer<ExamProvider, List<Exam>>(
          builder: (context, exams) {
            return Column(
              children: createExamsColumn(
                context,
                exams
                    .where(
                      (exam) =>
                          filteredExamTypes[Exam.getExamTypeLong(exam.type)] ??
                          true,
                    )
                    .toList(),
              ),
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
      ],
    );
  }

  /// Creates a column with all the user's exams.
  List<Widget> createExamsColumn(BuildContext context, List<Exam> exams) {
    if (exams.length == 1) {
      return [
        createExamCard(context, [exams[0]]),
      ];
    }

    final columns = <Widget>[];
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
      Container(
        padding: const EdgeInsets.only(top: 15, bottom: 3),
        alignment: Alignment.center,
        child: Text(
          '${exams.first.weekDay(locale)}, '
          '${exams.first.begin.formattedDate(locale)}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    ];
    for (var i = 0; i < exams.length; i++) {
      examCards.add(createExamContext(context, exams[i]));
    }
    return Column(children: examCards);
  }

  Widget createExamContext(BuildContext context, Exam exam) {
    final isHidden = hiddenExams.contains(exam.id);
    return Container(
      key: Key('$exam-exam'),
      margin: const EdgeInsets.fromLTRB(12, 4, 12, 0),
      child: RowContainer(
        color: isHidden
            ? Theme.of(context).hintColor
            : Theme.of(context).scaffoldBackgroundColor,
        child: ExamRow(
          exam: exam,
          teacher: '',
          mainPage: false,
          onChangeVisibility: () {
            setState(() {
              hiddenExams = PreferencesController.getHiddenExams();
            });
          },
        ),
      ),
    );
  }

  @override
  Future<void> onRefresh(BuildContext context) async {
    return Provider.of<ExamProvider>(context, listen: false)
        .forceRefresh(context);
  }

  @override
  String? getTitle() => S.of(context).nav_title(NavigationItem.navExams.route);

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
}
