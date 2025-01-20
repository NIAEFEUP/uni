import 'package:flutter/material.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/model/providers/lazy/exam_provider.dart';
import 'package:uni/view/home/widgets2/generic_home_card.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni_ui/cards/exam_card.dart';
import 'package:uni_ui/cards/timeline_card.dart';

class ExamHomeCard extends GenericHomecard {
  const ExamHomeCard({
    required super.title,
    super.key,
  });

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
            final items = buildTimelineItems(visibleExams).sublist(0, 2);

            return CardTimeline(items: items);
          },
          hasContent: (allExams) =>
              getVisibleExams(allExams, hiddenExams).isNotEmpty,
          onNullContent: const Center(
            child: Text('Sem exames'),
          ),
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

  List<TimelineItem> buildTimelineItems(List<Exam> exams) {
    final items = exams
        .map(
          (exam) => TimelineItem(
            title: exam.start.day.toString(),
            subtitle: exam.start.month.toString(),
            card: ExamCard(
              showIcon: false,
              name: exam.subject,
              acronym: exam.subjectAcronym,
              rooms: exam.rooms,
              type: exam.examType,
            ),
          ),
        )
        .toList();

    return items;
  }

  @override
  void onClick(BuildContext context) => {};
}
