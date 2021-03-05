import 'package:flutter/material.dart';
import 'package:uni/controller/parsers/parser_exams.dart';
import 'package:uni/model/entities/exam.dart';

class ExamFilterMenu extends StatefulWidget {
  Map<String, bool> checkboxes = {};
  String dropdownValue = 'Todos';
  bool checked = true;

  @override
  _ExamFilterMenuState createState() => _ExamFilterMenuState();
}

class _ExamFilterMenuState extends State<ExamFilterMenu> {
  @override
  void initState() {
    super.initState();
    widget.checkboxes = checkboxValues();
  }

  Map<String, bool> checkboxValues() {
    final Iterable<String> examTypes = Exam.getExamTypes().keys;
    final Map<String, bool> chekboxes = {'Todos': false};
    examTypes.forEach((type) => chekboxes[type] = false);
    return chekboxes;
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    final Widget okButton = FlatButton(
      child: Text('OK'),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    final AlertDialog alert = AlertDialog(
      content: Container(
        height: 350.0, // Change as per your requirement
        width: 200.0, //

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
                },
              );
            }).toList(),
          );
        }),
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // List<Checkbox> chekboxWidgets = widget.checkboxes.keys.map((String key) {
    //   return Checkbox(
    //     value: widget.checkboxes[key],
    //     onChanged: (bool value) {
    //       setState(() {
    //         widget.checkboxes[key] = value;
    //       });
    //     },
    //   );
    // }).toList();

    return IconButton(
      icon: Icon(Icons.filter_list),
      onPressed: () {
        showAlertDialog(context);
      },
    );

    // return PopupMenuButton(
    //   child: Text(
    //     "Checkbox PopupMenuBotton",
    //     style: TextStyle(color: Colors.white),
    //   ),
    //   itemBuilder: (context) => [
    //     CheckedPopupMenuItem(
    //       checked: true,
    //       child: Text("Bajarangisoft.com"),
    //     ),
    //     CheckedPopupMenuItem(
    //       child: Text("Flutter"),
    //     ),
    //     CheckedPopupMenuItem(
    //       child: Text("Google.com"),
    //     ),
    //   ],
    // );

    // String _selectedItem = 'Sun';
    // bool checkedValue = false;
    // List _options = [
    //   Row(
    //     children: [
    //       CheckboxListTile(
    //         title: Text("title text"),
    //         value: checkedValue,
    //         onChanged: (newValue) {
    //           setState(() {
    //             checkedValue = newValue;
    //           });
    //         },
    //         controlAffinity:
    //             ListTileControlAffinity.leading, //  <-- leading Checkbox
    //       )
    //     ],
    //   )
    // ];

    // return PopupMenuButton(
    //   itemBuilder: (BuildContext bc) {
    //     return _options
    //         .map((day) => PopupMenuItem(
    //               child: Text(day),
    //               value: day,
    //             ))
    //         .toList();
    //   },
    //   onSelected: (value) {
    //     setState(() {
    //       _selectedItem = value;
    //     });
    //   },
    // );

    // return DropdownButton<String>(
    //   icon: Icon(Icons.filter_list),
    //   items: widget.checkboxes.keys.map((String key) {
    //     return DropdownMenuItem<String>(
    //       value: '',
    //       child: Row(children: [
    //         Checkbox(
    //           value: widget.checkboxes[key],
    //           onChanged: (bool value) {
    //             setState(() {
    //               widget.checkboxes[key] = value;
    //             });
    //           },
    //         ),
    //         Text(key),
    //       ]),
    //     );
    //   }).toList(),
    //   onChanged: (_) {},
    //   hint: Text('Select value'),
    // );
  }
}
