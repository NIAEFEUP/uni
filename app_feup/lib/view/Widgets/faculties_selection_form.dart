import 'package:flutter/material.dart';
import 'package:uni/utils/constants.dart' as Constants;

class FacultiesSelectionForm extends StatefulWidget {
  final faculties;
  final Function setFaculties;
  final Brightness brightness;

  FacultiesSelectionForm(this.faculties, this.setFaculties, this.brightness);

  @override
  State<StatefulWidget> createState() => _FacultiesSelectionFormState();
}

class _FacultiesSelectionFormState extends State<FacultiesSelectionForm> {
  @override
  Widget build(BuildContext context) {
    final Color textColor = Color.fromARGB(255, 0xfa, 0xfa, 0xfa);
    Color backgroundColor;
    if (widget.brightness == Brightness.dark) {
      backgroundColor = Color.fromARGB(255, 27, 27, 27);
    } else {
      backgroundColor = Color.fromARGB(255, 0x75, 0x17, 0x1e);
    }

    return AlertDialog(
        backgroundColor: backgroundColor,
        title: Text('seleciona a(s) tua(s) faculdade(s)'),
        titleTextStyle: TextStyle(
            color: textColor,
            fontSize: 18
        ),
        content: Container(
            height: 500.0,
            width: 200.0,
            child: createCheckList(context)
        ),
        actions: createActionButtons(context)
    );
  }

  List<Widget> createActionButtons(BuildContext context) {
    final Color primaryColor = Color.fromARGB(255, 0xfa, 0xfa, 0xfa);
    Color onPrimaryColor;
    if (widget.brightness == Brightness.dark) {
      onPrimaryColor = Color.fromARGB(255, 27, 27, 27);
    } else {
      onPrimaryColor = Color.fromARGB(255, 0x75, 0x17, 0x1e);
    }

    return [
      TextButton(
          child: Text('Cancelar'),
          style: TextButton.styleFrom(
              primary: primaryColor),
          onPressed: () => Navigator.pop(context)
      ),
      ElevatedButton(
          child: Text('Confirmar'),
          style: ElevatedButton.styleFrom(
              primary: primaryColor,
              onPrimary: onPrimaryColor
          ),
          onPressed: () {
            Navigator.pop(context);
            widget.setFaculties(widget.faculties);
          }
      )
    ];
  }

  Widget createCheckList(BuildContext context) {
    final Color textColor = Color.fromARGB(255, 0xfa, 0xfa, 0xfa);
    Color activeColor;
    if (widget.brightness == Brightness.dark) {
      activeColor = Color.fromARGB(255, 27, 27, 27);
    } else {
      activeColor = Color.fromARGB(255, 0x75, 0x17, 0x1e);
    }

    return ListView(
      children: List.generate(
        Constants.faculties.length, (i) {
          final String faculty = Constants.faculties.elementAt(i);
          return CheckboxListTile(
            title: Text(
                faculty.toUpperCase(),
                style: TextStyle(
                    color: textColor,
                    fontSize: 20.0
                )
            ),
            activeColor: activeColor,
            key: Key('FacultyCheck' + faculty),
            value: widget.faculties.contains(faculty),
            onChanged: (value) {
              setState(() {
                if (value) {
                  widget.faculties.add(faculty);
                } else {
                  widget.faculties.remove(faculty);
                }
              });
            }
          );
        }
      )
    );
  }
}