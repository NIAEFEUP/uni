import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/redux/action_creators.dart';

class ExamForm extends StatefulWidget {
  Map<String, bool> filteredExams = Map();

  ExamForm(this.filteredExams);
  @override
  _ExamFormState createState() => _ExamFormState();
}

class _ExamFormState extends State<ExamForm> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        FlatButton(
            child: Text('Ok',
                style: Theme.of(context)
                    .textTheme
                    .display1
                    .apply(color: Theme.of(context).accentColor)),
            color: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(color: Theme.of(context).primaryColor)),
            onPressed: () {
              StoreProvider.of<AppState>(context).dispatch(
                  setFilteredExams(widget.filteredExams, Completer()));
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
      final String zas = filteredExams.keys.elementAt(i);
      return Row(
        children: <Widget>[
          Flexible(
              child: Text(zas, overflow: TextOverflow.fade, softWrap: false)),
          Checkbox(
              value: filteredExams[zas],
              onChanged: (value) {
                setState(() {
                  filteredExams[zas] = value;
                });
              },
              activeColor: Theme.of(context).primaryColor),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      );
    }));
    // return ListView.builder(
    //   itemCount: filteredExams.length,
    //   itemBuilder: (BuildContext context, int index) {
    //     final String key = filteredExams.keys.elementAt(index);
    //     return CheckboxListTile(
    //       title: Text(key),
    //       activeColor: Theme.of(context).primaryColor,
    //       value: filteredExams[key],
    //       onChanged: (bool value) {
    //         StoreProvider.of<AppState>(context).dispatch(
    //             setFilteredExams(widget.filteredExams, Completer()));
    //         //filteredExams[key] = !filteredExams[key];
    //       },
    //     );
    //   },
    // );
  }
}
