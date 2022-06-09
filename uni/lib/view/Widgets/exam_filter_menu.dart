import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/view/Widgets/exam_filter_form.dart';

// ignore: must_be_immutable
class ExamFilterMenu extends StatefulWidget {
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
              return getAlertDialog(filteredExams, context);
            });
      },
    );
  }

  Widget getAlertDialog(Map<String, bool> filteredExams, BuildContext context) {
    return ExamFilterForm(Map<String, bool>.from(filteredExams));
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.settings),
      onPressed: () {
        showAlertDialog(context);
      },
    );
  }
}
