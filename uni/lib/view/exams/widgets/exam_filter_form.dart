import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/redux/action_creators.dart';

class ExamFilterForm extends StatefulWidget {
  final Map<String, bool> filteredExams;

  const ExamFilterForm(this.filteredExams, {super.key});
  @override
  ExamFilterFormState createState() => ExamFilterFormState();
}

class ExamFilterFormState extends State<ExamFilterForm> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Definições Filtro de Exames',
          style: Theme.of(context).textTheme.headline5),
      actions: [
        TextButton(
            child:
                Text('Cancelar', style: Theme.of(context).textTheme.bodyText2),
            onPressed: () => Navigator.pop(context)),
        ElevatedButton(
            child: const Text('Confirmar'),
            onPressed: () {
              StoreProvider.of<AppState>(context).dispatch(
                  setFilteredExams(widget.filteredExams, Completer()));

              Navigator.pop(context);
            })
      ],
      content: SizedBox(
          height: 300.0,
          width: 200.0,
          child: getExamCheckboxes(widget.filteredExams, context)),
    );
  }

  Widget getExamCheckboxes(
      Map<String, bool> filteredExams, BuildContext context) {
    filteredExams
        .removeWhere((key, value) => !Exam.getExamTypes().containsKey(key));
    return ListView(
        children: List.generate(filteredExams.length, (i) {
      final String key = filteredExams.keys.elementAt(i);
      if (!Exam.getExamTypes().containsKey(key)) return const Text("");
      return CheckboxListTile(
          contentPadding: const EdgeInsets.all(0),
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
          });
    }));
  }
}
