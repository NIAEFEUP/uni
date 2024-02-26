import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/model/providers/lazy/exam_provider.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/common_widgets/generic_card.dart';
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

  static const int maxExamsToDisplay = 4;

  @override
  String getTitle(BuildContext context) =>
      S.of(context).nav_title(NavigationItem.navExams.route);

  @override
  Future<Object?> onClick(BuildContext context) =>
      Navigator.pushNamed(context, '/${NavigationItem.navExams.route}');

  @override
  void onRefresh(BuildContext context) {
    Provider.of<ExamProvider>(context, listen: false).forceRefresh(context);
  }

  @override
  Widget buildCardContent(BuildContext context) {
    return StreamBuilder(
      stream: PreferencesController.onHiddenExamsChange,
      initialData: PreferencesController.getHiddenExams(),
      builder: (context, snapshot) {
        final hiddenExams = snapshot.data ?? [];

        return LazyConsumer<ExamProvider, List<Exam>>(
          builder: (context, allExams) {
            final visibleExams =
                getVisibleExams(allExams, hiddenExams).toList();

            final nextExams = getPrimaryExams(
              visibleExams,
            );

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                NextExamsWidget(exams: nextExams),
                if (nextExams.length < maxExamsToDisplay &&
                    visibleExams.length > nextExams.length)
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
                      RemainingExamsWidget(
                        exams: visibleExams
                            .where((exam) => !nextExams.contains(exam))
                            .take(maxExamsToDisplay - nextExams.length)
                            .toList(),
                      ),
                    ],
                  ),
              ],
            );
          },
          hasContent: (allExams) =>
              getVisibleExams(allExams, hiddenExams).isNotEmpty,
          onNullContent: Center(
            child: Text(
              S.of(context).no_selected_exams,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          contentLoadingWidget: const ExamCardShimmer(),
        );
      },
    );
  }

  Iterable<Exam> getVisibleExams(
    List<Exam> allExams,
    List<String> hiddenExams,
  ) {
    final hiddenExamsSet = Set<String>.from(hiddenExams);
    return allExams.where((exam) => !hiddenExamsSet.contains(exam.id));
  }

  List<Exam> getPrimaryExams(List<Exam> visibleExams) {
    return visibleExams
        .where((exam) => isSameDay(visibleExams[0].begin, exam.begin))
        .toList();
  }

  bool isSameDay(DateTime? dateA, DateTime? dateB) {
    return dateA?.year == dateB?.year &&
        dateA?.month == dateB?.month &&
        dateA?.day == dateB?.day;
  }
}
