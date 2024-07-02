import 'package:flutter/material.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/exam.dart';

class ExamFilterForm extends StatefulWidget {
  const ExamFilterForm(this.filteredExamsTypes, this.onDismiss, {super.key});

  final Map<String, bool> filteredExamsTypes;
  final void Function() onDismiss;

  @override
  ExamFilterFormState createState() => ExamFilterFormState();
}

class ExamFilterFormState extends State<ExamFilterForm> {
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
        ElevatedButton(
          child: Text(S.of(context).confirm),
          onPressed: () {
            PreferencesController.saveFilteredExams(
              widget.filteredExamsTypes,
            );
            widget.onDismiss();
            Navigator.pop(context);
          },
        ),
      ],
      content: SizedBox(
        height: 230,
        width: 200,
        child: getExamCheckboxes(widget.filteredExamsTypes, context),
      ),
    );
  }

  Widget getExamCheckboxes(
    Map<String, bool> filteredExams,
    BuildContext context,
  ) {
    filteredExams.removeWhere((key, value) => !Exam.types.containsKey(key));
    return ListView(
      children: List.generate(filteredExams.length, (i) {
        final key = filteredExams.keys.elementAt(i);
        if (!Exam.types.containsKey(key)) {
          return const Text('');
        }
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
            setState(() {
              filteredExams[key] = value!;
            });
          },
        );
      }),
    );
  }
}
