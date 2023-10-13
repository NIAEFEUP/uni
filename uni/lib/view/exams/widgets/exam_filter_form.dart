import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/model/providers/lazy/exam_provider.dart';

class ExamFilterForm extends StatefulWidget {
  const ExamFilterForm(this.filteredExamsTypes, {super.key});
  final Map<String, bool> filteredExamsTypes;

  Map<String, bool> get filteredExamTypes =>
      Map<String, bool>.from(filteredExamsTypes)
        ..removeWhere((key, value) => !Exam.types.containsKey(key));

  @override
  ExamFilterFormState createState() => ExamFilterFormState();
}

class ExamFilterFormState extends State<ExamFilterForm> {
  void _changeFilteredExamList(String key, {bool? value}) {
    setState(() {
      widget.filteredExamsTypes[key] = value!;
      Provider.of<ExamProvider>(context, listen: false)
          .setFilteredExams(widget.filteredExamsTypes);
    });
  }

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
            Provider.of<ExamProvider>(context, listen: false)
                .setFilteredExams(widget.filteredExamsTypes);
            Navigator.pop(context);
          },
        ),
      ],
      content: SizedBox(
        height: 230,
        width: 200,
        child: FilteredExamList(
          widget.filteredExamsTypes,
          _changeFilteredExamList,
          context,
        ),
      ),
    );
  }
}

class FilteredExamList extends StatelessWidget {
  const FilteredExamList(
    this.filteredExams,
    this.changeFilteredExamList,
    this.context, {
    super.key,
  });
  final Map<String, bool> filteredExams;
  final void Function(String, {bool? value}) changeFilteredExamList;
  final BuildContext context;

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
          onChanged: (value) => {changeFilteredExamList(key, value: value)},
        );
      }),
    );
  }
}
