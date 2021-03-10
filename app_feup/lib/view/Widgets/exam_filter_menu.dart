import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/redux/action_creators.dart';

// ignore: must_be_immutable
class ExamFilterMenu extends StatefulWidget {
  final Map<String, bool> checkboxes;

  ExamFilterMenu(this.checkboxes);

  @override
  _ExamFilterMenuState createState() => _ExamFilterMenuState();
}

class _ExamFilterMenuState extends State<ExamFilterMenu> {
  showAlertDialog(BuildContext context) {
    // set up the AlertDialog
    final AlertDialog alert = AlertDialog(
      content: Container(
        height: 300.0,
        width: 200.0,
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return ListView(
            children: widget.checkboxes.keys.map((String key) {
              return CheckboxListTile(
                title: Text(key),
                value: widget.checkboxes[key],
                onChanged: (bool value) {
                  setState(() {
                    widget.checkboxes[key] = value;
                  });
                  StoreProvider.of<AppState>(context)
                      .dispatch(setFilteredExams(key, Completer()));
                },
              );
            }).toList(),
          );
        }),
      ),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
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
