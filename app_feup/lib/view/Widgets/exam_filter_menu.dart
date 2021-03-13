import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/redux/action_creators.dart';

// ignore: must_be_immutable
class ExamFilterMenu extends StatefulWidget {
  //TODO
  //Verificar o que acontece quando ele nao tem shared preferences
  @override
  _ExamFilterMenuState createState() => _ExamFilterMenuState();
}

class _ExamFilterMenuState extends State<ExamFilterMenu> {
  showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StoreConnector<AppState, Map<String, bool>>(
            converter: (store) => store.state.content['filteredExams'],
            builder: (context, filteredExams) {
              return getAlertDialog(filteredExams);
            });
      },
    );
  }

  Widget getExamCheckboxes(Map<String, bool> filteredExams) {
    return ListView(
      children: filteredExams.keys.map((String key) {
        return CheckboxListTile(
          title: Text(key),
          value: filteredExams[key],
          onChanged: (bool value) {
            setState(() {
              StoreProvider.of<AppState>(context)
                  .dispatch(setFilteredExams(key, Completer()));
            });
          },
        );
      }).toList(),
    );
  }

  Widget getAlertDialog(Map<String, bool> filteredExams) {
    return AlertDialog(
      content: Container(
          height: 300.0,
          width: 200.0,
          child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return getExamCheckboxes(filteredExams);
          })),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.filter_list),
      onPressed: () {
        showAlertDialog(context);
      },
    );
  }
}
