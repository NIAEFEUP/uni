import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/providers/lazy/exam_provider.dart';
import 'package:uni/view/exams/widgets/exam_filter_form.dart';
import 'package:uni/view/lazy_consumer.dart';

class ExamFilterMenu extends StatefulWidget {
  const ExamFilterMenu({super.key});

  @override
  ExamFilterMenuState createState() => ExamFilterMenuState();
}

class ExamFilterMenuState extends State<ExamFilterMenu> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.filter_alt),
      onPressed: () {
        showDialog<void>(
          context: context,
          builder: (_) {
            return LazyConsumer<ExamProvider>(
              builder: (context, examProvider) {
                return ExamFilterForm(
                    Map<String, bool>.from(examProvider.filteredExamsTypes),
                    (newFilteredExams) {
                  examProvider.setFilteredExams(newFilteredExams);
                });
              },
            );
          },
        );
      },
    );
  }
}
