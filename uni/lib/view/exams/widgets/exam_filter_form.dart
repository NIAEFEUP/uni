import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/model/providers/lazy/exam_provider.dart';

class ExamFilterForm extends StatefulWidget {
  const ExamFilterForm(this.filteredExamsTypes, {super.key});
  final Map<String, bool> filteredExamsTypes;

  @override
  ExamFilterFormState createState() => ExamFilterFormState();
}

class ExamFilterFormState extends State<ExamFilterForm> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Definições Filtro de Exames',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      actions: [
        TextButton(
          child:
              Text('Cancelar', style: Theme.of(context).textTheme.bodyMedium),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          child: const Text('Confirmar'),
          onPressed: () {
            Provider.of<ExamProvider>(context, listen: false)
                .setFilteredExams(widget.filteredExamsTypes);
            Navigator.pop(context);
          },
        )
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
            setState(() {
              filteredExams[key] = value!;
            });
          },
        );
      }),
    );
  }
}
