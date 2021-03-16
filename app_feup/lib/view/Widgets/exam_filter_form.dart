import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/redux/action_creators.dart';

class ExamFilterForm extends StatefulWidget {
  final Map<String, bool> filteredExams;

  ExamFilterForm(this.filteredExams);
  @override
  _ExamFilterFormState createState() => _ExamFilterFormState();
}

class _ExamFilterFormState extends State<ExamFilterForm> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        TextButton(
            child: Text('Cancelar',
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .apply(color: Theme.of(context).primaryColor)),
            onPressed: () => Navigator.pop(context)),
        TextButton(
            child: Text('Confirmar',
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .apply(color: Theme.of(context).accentColor)),
            color: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(color: Theme.of(context).primaryColor)),
            onPressed: () {
              StoreProvider.of<AppState>(context).dispatch(
                  setFilteredExams(widget.filteredExams, Completer()));

              Navigator.pop(context);
            })
      ],
      content: Container(
          height: 300.0,
          width: 200.0,
          child: getExamCheckboxes(widget.filteredExams, context)),
    );
  }

  Widget getExamCheckboxes(
      Map<String, bool> filteredExams, BuildContext context) {
    return ListView(
        children: List.generate(filteredExams.length, (i) {
      final String key = filteredExams.keys.elementAt(i);
      return Row(
        children: <Widget>[
          Flexible(
              child: Text(
            key,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            maxLines: 2,
          )),
          Checkbox(
              value: filteredExams[key],
              onChanged: (value) {
                setState(() {
                  filteredExams[key] = value;
                });
              },
              activeColor: Theme.of(context).primaryColor),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      );
    }));
  }
}
