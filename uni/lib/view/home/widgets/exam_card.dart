import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/app_locale.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/model/providers/lazy/exam_provider.dart';
import 'package:uni/utils/drawer_items.dart';
import 'package:uni/view/common_widgets/date_rectangle.dart';
import 'package:uni/view/common_widgets/generic_card.dart';
import 'package:uni/view/common_widgets/request_dependent_widget_builder.dart';
import 'package:uni/view/common_widgets/row_container.dart';
import 'package:uni/view/exams/widgets/exam_row.dart';
import 'package:uni/view/exams/widgets/exam_title.dart';
import 'package:uni/view/home/widgets/exam_card_shimmer.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni/view/locale_notifier.dart';

/// Manages the exam card section inside the personal area.
class ExamCard extends GenericCard {
  ExamCard({super.key});

  const ExamCard.fromEditingInformation(
    super.key, {
    required super.editingMode,
    super.onDelete,
  }) : super.fromEditingInformation();

  @override
  String getTitle(BuildContext context) =>
      S.of(context).nav_title(DrawerItem.navExams.title);

  @override
  Future<Object?> onClick(BuildContext context) =>
      Navigator.pushNamed(context, '/${DrawerItem.navExams.title}');

  @override
  void onRefresh(BuildContext context) {
    Provider.of<ExamProvider>(context, listen: false).forceRefresh(context);
  }

  /// Returns a widget with all the exams card content.
  ///
  /// If there are no exams, a message telling the user
  /// that no exams exist is displayed.
  @override
  Widget buildCardContent(BuildContext context) {
    return LazyConsumer<ExamProvider>(
      builder: (context, examProvider) {
        final filteredExams = examProvider.getFilteredExams();
        final hiddenExams = examProvider.hiddenExams;
        final exams = filteredExams
            .where((exam) => !hiddenExams.contains(exam.id))
            .toList();
        return RequestDependentWidgetBuilder(
          status: examProvider.status,
          builder: () => generateExams(exams, context),
          hasContentPredicate: exams.isNotEmpty,
          onNullContent: Center(
            child: Text(
              S.of(context).no_selected_exams,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          contentLoadingWidget: const ExamCardShimmer().build(context),
        );
      },
    );
  }

  /// Returns a widget with all the exams.
  Widget generateExams(List<Exam> exams, BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: getExamRows(context, exams),
    );
  }

  /// Returns true if two exams are in the same day
  bool isSameDay(DateTime datetime1, DateTime datetime2) {
    return datetime1.year == datetime2.year
           && datetime1.month == datetime2.month
           && datetime1.day == datetime2.day;
  }

  /// Returns a list of widgets with the primary and secondary exams to
  /// be displayed in the exam card.
  List<Widget> getExamRows(BuildContext context, List<Exam> exams) {
    final rows = <Widget>[];

    rows.add(createRowFromExam(context, exams[0], isFirst: true));

    var sameDayExamCount = exams.sublist(1).takeWhile(
          (exam) => isSameDay(exam.begin, exams[0].begin),
    ).toList().fold(0, (count, exam) {
      rows.addAll([
        Container(
          margin: const EdgeInsets.only(top: 8),
        ),
        createRowFromExam(context, exam),
      ]);
      return count + 1;
    });

    if (exams.length > 1 && sameDayExamCount > 0) {
      rows.add(
        Container(
          margin: const EdgeInsets.only(right: 80, left: 80, top: 15, bottom: 7),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1.5,
                color: Theme.of(context).dividerColor,
              ),
            ),
          ),
        ),
      );
    }

    // Processing secondary exams without a loop
    exams.sublist(1 + sameDayExamCount)
        .take(4 - sameDayExamCount - 1)
        .forEach((exam) => rows.add(createSecondaryRowFromExam(context, exam)));

    return rows;
  }

  /// Creates a row with the closest exam (which appears separated from the
  /// others in the card).
  Widget createRowFromExam(BuildContext context, Exam exam, {bool isFirst = false}) {
    final locale = Provider.of<LocaleNotifier>(context).getLocale();
    return Column(
      children: [
        if(isFirst) ...[
          if (locale == AppLocale.pt) ...[
            DateRectangle(
              date: '''${exam.weekDay(locale)}, '''
                  '''${exam.begin.day} de ${exam.month(locale)}''',
            ),
          ] else ...[
            DateRectangle(
              date: '''${exam.weekDay(locale)}, '''
                  '''${exam.begin.day} ${exam.month(locale)}''',
            ),
          ],
        ],
        RowContainer(
          child: ExamRow(
            exam: exam,
            teacher: '',
            mainPage: true,
          ),
        ),
      ],
    );
  }

  /// Creates a row for the exams which will be displayed under the closest
  /// date exam with a separator between them.
  Widget createSecondaryRowFromExam(BuildContext context, Exam exam) {
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
                '${exam.begin.day} de ${exam.month(locale)}',
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
  }
}
