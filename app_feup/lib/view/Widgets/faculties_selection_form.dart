import 'package:flutter/material.dart';
import 'package:uni/utils/constants.dart' as Constants;

class FacultiesSelectionForm extends StatefulWidget {
  final List<String> userFaculties;

  FacultiesSelectionForm({@required this.userFaculties});

  @override
  State<StatefulWidget> createState() => _FacultiesSelectionForm();
}

class _FacultiesSelectionForm extends State<FacultiesSelectionForm> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: Theme.of(context).accentColor,
        title: Text('seleciona a(s) tua(s) faculdade(s)'),
        titleTextStyle: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 18
        ),
        content: Container(
            height: 500.0,
            width: 200.0,
            child: createCheckList()
        )
    );
  }

  Widget createCheckList() {
    return ListView(
      children: List.generate(
        Constants.faculties.length,
            (i) {
          final String faculty = Constants.faculties.elementAt(i);
          return CheckboxListTile(
            title: Text(
                faculty.toUpperCase(),
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 20.0
                )
            ),
            key: Key('FacultyCheck' + faculty),
            value: widget.userFaculties.contains(faculty),
            onChanged: (value) {
              setState(() {
                if (value) {
                  widget.userFaculties.add(faculty);
                } else {
                  widget.userFaculties.remove(faculty);
                }
              });
            }
          );
        }
      )
    );
  }
}