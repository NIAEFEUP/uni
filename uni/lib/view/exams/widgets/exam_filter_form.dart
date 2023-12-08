import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/exam.dart';

class ExamFilterForm extends StatelessWidget {
  const ExamFilterForm(
    this.filteredExamsTypes,
    this.setExamsTypesCallback, {
    super.key,
  });

  final Map<String, bool> filteredExamsTypes;
  final void Function(Map<String, bool>) setExamsTypesCallback;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        S.of(context).exams_filter,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      actions: [
        TextButton(
          child: Text(
            S.of(context).cancel,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ],
      content: SizedBox(
        height: 230,
        width: 200,
        child: FilteredExamList(
          UnmodifiableMapView(
            Map<String, bool>.from(filteredExamsTypes)
              ..removeWhere((key, value) => !Exam.types.containsKey(key)),
          ),
          setExamsTypesCallback,
        ),
      ),
    );
  }
}

class FilteredExamList extends StatelessWidget {
  const FilteredExamList(
    this.filteredExams,
    this.changeFilteredExamList, {
    super.key,
  });

  final UnmodifiableMapView<String, bool> filteredExams;
  final void Function(Map<String, bool>) changeFilteredExamList;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: List.generate(filteredExams.length, (i) {
        final key = filteredExams.keys.elementAt(i);
        if (!Exam.types.containsKey(key)) return const Text('');
        return CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            key,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            maxLines: 2,
          ),
          key: Key('ExamCheck$key'),
          value: filteredExams[key],
          onChanged: (value) {
            final newFilteredExams = Map<String, bool>.from(filteredExams);
            newFilteredExams[key] = value!;
            changeFilteredExamList(newFilteredExams);
          },
        );
      }),
    );
  }
}
