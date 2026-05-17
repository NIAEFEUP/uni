import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/model/providers/riverpod/default_consumer.dart';
import 'package:uni/model/providers/riverpod/exam_provider.dart';
import 'package:uni/utils/date_time_formatter.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/utils/string_formatter.dart';
import 'package:uni/view/home/widgets/generic_home_card.dart';
import 'package:uni/view/home/widgets/schedule/timeline_shimmer.dart';
import 'package:uni/view/locale_notifier.dart';
import 'package:uni/view/widgets/icon_label.dart';
import 'package:uni_ui/cards/exam_card.dart';
import 'package:uni_ui/cards/timeline_card.dart';
import 'package:uni_ui/icons.dart';

class ExamHomeCard extends GenericHomecard {
  const ExamHomeCard({super.key})
    : super(
        titlePadding: const EdgeInsets.symmetric(horizontal: 20),
        bodyPadding: const EdgeInsets.symmetric(horizontal: 20),
      );

  @override
  String getTitle(BuildContext context) {
    return S.of(context).exams;
  }

  @override
  Widget buildCardContent(BuildContext context) {
    return StreamBuilder(
      stream: PreferencesController.onHiddenExamsChange,
      initialData: PreferencesController.getHiddenExams(),
      builder: (context, snapshot) {
        final hiddenExams = snapshot.data ?? [];

        return DefaultConsumer<List<Exam>>(
          provider: examProvider,
          builder: (context, ref, allExams) {
            final visibleExams = getVisibleExams(
              allExams,
              hiddenExams,
            ).take(2).toList();
            final items = buildTimelineItems(ref, visibleExams);

            return CardTimeline(items: items.toList());
          },
          hasContent: (allExams) =>
              getVisibleExams(allExams, hiddenExams).isNotEmpty,
          nullContentWidget: Center(
            child: IconLabel(
              icon: UniIcon(
                size: 45,
                UniIcons.island,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
              label: S.of(context).no_exams,
              labelTextStyle: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          loadingWidget: const ShimmerCardTimeline(),
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

  List<TimelineItem> buildTimelineItems(WidgetRef ref, List<Exam> exams) {
    final locale = ref.watch(localeProvider);
    final groups = _groupExamsByDay(exams);

    return groups.map((group) {
      final firstExam = group.first;

      return TimelineItem(
        title: firstExam.start.day.toString(),
        subtitle: firstExam.start.shortMonth(locale).capitalize(),
        card: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: group.map((exam) {
            return ExamCard(
              showIcon: false,
              name: exam.subject,
              acronym: exam.subjectAcronym,
              rooms: exam.rooms,
              type: exam.examType,
              startTime: exam.startTime,
            );
          }).toList(),
        ),
      );
    }).toList();
  }

  List<List<Exam>> _groupExamsByDay(List<Exam> exams) {
    if (exams.isEmpty) {
      return [];
    }
    final sorted = [...exams]..sort((a, b) => a.start.compareTo(b.start));

    final groups = <List<Exam>>[];
    var currentGroup = [sorted.first];
    var currentDay = sorted.first.start.day;

    for (final exam in sorted.skip(1)) {
      if (exam.start.day == currentDay) {
        currentGroup.add(exam);
      } else {
        groups.add(currentGroup);
        currentGroup = [exam];
        currentDay = exam.start.day;
      }
    }
    groups.add(currentGroup);

    return groups;
  }

  @override
  void onCardClick(BuildContext context) {
    Navigator.pushNamed(
      context,
      '/${NavigationItem.navAcademicPath.route}',
      arguments: 2,
    );
  }
}
