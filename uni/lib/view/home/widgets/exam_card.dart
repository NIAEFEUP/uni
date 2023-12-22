import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/model/providers/lazy/exam_provider.dart';
import 'package:uni/utils/drawer_items.dart';
import 'package:uni/view/common_widgets/generic_card.dart';
import 'package:uni/view/common_widgets/request_dependent_widget_builder.dart';
import 'package:uni/view/home/widgets/exam_card_shimmer.dart';
import 'package:uni/view/home/widgets/next_exams_card.dart';
import 'package:uni/view/home/widgets/remaining_exams_card.dart';
import 'package:uni/view/lazy_consumer.dart';

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

  @override
  Widget buildCardContent(BuildContext context) {
    return LazyConsumer<ExamProvider>(
      builder: (context, examProvider) {
        final filteredExams = examProvider.getFilteredExams();
        final hiddenExams = examProvider.hiddenExams;
        final allExams = filteredExams
            .where((exam) => !hiddenExams.contains(exam.id))
            .toList();
        return RequestDependentWidgetBuilder(
          status: examProvider.status,
          builder: () => generateExams(allExams, context),
          hasContentPredicate: allExams.isNotEmpty,
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

  Widget generateExams(List<Exam> allExams, BuildContext context) {
    final nextExams = getPrimaryExams(
      allExams,
      allExams.isNotEmpty ? allExams.first : null,
    );
    final primaryExams = NextExamsWidget(exams: nextExams);

    final remainingExamsCount = 4 - nextExams.length;
    final List<Exam> remainingExams;
    if (remainingExamsCount > 0) {
      remainingExams = allExams
          .where((exam) => !nextExams.contains(exam))
          .take(remainingExamsCount)
          .toList();
    } else {
      remainingExams = [];
    }
    final secondaryExams = RemainingExamsWidget(exams: remainingExams);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        primaryExams,
        if (remainingExamsCount > 0)
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                  right: 80,
                  left: 80,
                  top: 7,
                  bottom: 7,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                ),
              ),
              secondaryExams,
            ],
          ),
      ],
    );
  }

  List<Exam> getPrimaryExams(List<Exam> allExams, Exam? nextExam) {
    if (nextExam == null) {
      return [];
    }

    final sameDayExams = allExams.where((exam) {
      final nextExamDate = DateTime(
        nextExam.begin.year,
        nextExam.begin.month,
        nextExam.begin.day,
      );
      final examDate =
          DateTime(exam.begin.year, exam.begin.month, exam.begin.day);
      return nextExamDate.isAtSameMomentAs(examDate);
    }).toList();

    return sameDayExams;
  }
}
