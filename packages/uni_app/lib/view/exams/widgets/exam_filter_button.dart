import 'package:flutter/material.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/view/exams/widgets/exam_filter_form.dart';

class ExamFilterButton extends StatelessWidget {
  const ExamFilterButton(this.onDismissFilterDialog, {super.key});

  final void Function() onDismissFilterDialog;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.filter_list),
      onPressed: () {
        showDialog<void>(
          context: context,
          builder: (_) {
            final filteredExamsTypes = PreferencesController.getFilteredExams();
            return ExamFilterForm(
              Map<String, bool>.from(filteredExamsTypes),
              onDismissFilterDialog,
            );
          },
        );
      },
    );
  }
}
