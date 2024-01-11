import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/app_locale.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/model/providers/lazy/exam_provider.dart';
import 'package:uni/utils/date_time_formatter.dart';
import 'package:uni/utils/drawer_items.dart';
import 'package:uni/view/common_widgets/date_rectangle.dart';
import 'package:uni/view/common_widgets/generic_card.dart';
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
    return LazyConsumer<ExamProvider, List<Exam>>(
      builder: (context, exams) {
        return generateExams(shownExams(exams), context);
      },
      hasContent: (exams) => shownExams(exams).isNotEmpty,
      onNullContent: Center(
        child: Text(
          S.of(context).no_selected_exams,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      contentLoadingWidget: const ExamCardShimmer().build(context),
    );
  }

  List<Exam> shownExams(List<Exam> exams) {
    final filteredExams = PreferencesController.getFilteredExams();
    final hiddenExams = PreferencesController.getHiddenExams();

    return exams
        .where(
          (exam) =>
              !hiddenExams.contains(exam.id) &&
              (filteredExams[Exam.getExamTypeLong(exam.type)] ?? true),
        )
        .toList();
  }

  /// Returns a widget with all the exams.
  Widget generateExams(List<Exam> exams, BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: getExamRows(context, exams),
    );
  }

  /// Returns a list of widgets with the primary and secondary exams to
  /// be displayed in the exam card.
  List<Widget> getExamRows(BuildContext context, List<Exam> exams) {
    final rows = <Widget>[];
    for (var i = 0; i < 1 && i < exams.length; i++) {
      rows.add(createRowFromExam(context, exams[i]));
    }
    if (exams.length > 1) {
      rows.add(
        Container(
          margin:
              const EdgeInsets.only(right: 80, left: 80, top: 15, bottom: 7),
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
    for (var i = 1; i < 4 && i < exams.length; i++) {
      rows.add(createSecondaryRowFromExam(context, exams[i]));
    }
    return rows;
  }

  /// Creates a row with the closest exam (which appears separated from the
  /// others in the card).
  Widget createRowFromExam(BuildContext context, Exam exam) {
    final locale = Provider.of<LocaleNotifier>(context).getLocale();
    return Column(
      children: [
        if (locale == AppLocale.pt) ...[
          DateRectangle(
            date: exam.begin.formattedDate(locale),
          ),
        ] else ...[
          DateRectangle(
            date: exam.begin.formattedDate(locale),
          ),
        ],
        RowContainer(
          child: ExamRow(
            exam: exam,
            teacher: '',
            mainPage: true,
            onChangeVisibility: () {},
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
  }
}
