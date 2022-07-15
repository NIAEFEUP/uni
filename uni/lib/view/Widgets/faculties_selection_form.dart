import 'package:flutter/material.dart';
import 'package:uni/utils/constants.dart' as constants;

class FacultiesSelectionForm extends StatefulWidget {
  final List<String> faculties;
  final Function setFaculties;
  final Brightness brightness;

  const FacultiesSelectionForm(
      this.faculties, this.setFaculties, this.brightness,
      {super.key});

  @override
  State<StatefulWidget> createState() => _FacultiesSelectionFormState();
}

class _FacultiesSelectionFormState extends State<FacultiesSelectionForm> {
  @override
  Widget build(BuildContext context) {
    const Color textColor = Color.fromARGB(255, 0xfa, 0xfa, 0xfa);
    Color backgroundColor;
    if (widget.brightness == Brightness.dark) {
      backgroundColor = const Color.fromARGB(255, 27, 27, 27);
    } else {
      backgroundColor = const Color.fromARGB(255, 0x75, 0x17, 0x1e);
    }

    return AlertDialog(
        backgroundColor: backgroundColor,
        title: const Text('seleciona a(s) tua(s) faculdade(s)'),
        titleTextStyle: const TextStyle(color: textColor, fontSize: 18),
        content: SizedBox(
            height: 500.0, width: 200.0, child: createCheckList(context)),
        actions: createActionButtons(context));
  }

  List<Widget> createActionButtons(BuildContext context) {
    const Color backgroundColor = Color.fromARGB(255, 0xfa, 0xfa, 0xfa);
    Color foregroundColor;
    if (widget.brightness == Brightness.dark) {
      foregroundColor = const Color.fromARGB(255, 27, 27, 27);
    } else {
      foregroundColor = const Color.fromARGB(255, 0x75, 0x17, 0x1e);
    }

    return [
      TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar')),
      ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor),
          onPressed: () {
            Navigator.pop(context);
            widget.setFaculties(widget.faculties);
          },
          child: const Text('Confirmar'))
    ];
  }

  Widget createCheckList(BuildContext context) {
    const Color textColor = Color.fromARGB(255, 0xfa, 0xfa, 0xfa);
    Color activeColor;
    if (widget.brightness == Brightness.dark) {
      activeColor = const Color.fromARGB(255, 27, 27, 27);
    } else {
      activeColor = const Color.fromARGB(255, 0x75, 0x17, 0x1e);
    }

    return ListView(
        children: List.generate(constants.faculties.length, (i) {
      final String faculty = constants.faculties.elementAt(i);
      return CheckboxListTile(
          title: Text(faculty.toUpperCase(),
              style: const TextStyle(color: textColor, fontSize: 20.0)),
          activeColor: activeColor,
          key: Key('FacultyCheck$faculty'),
          value: widget.faculties.contains(faculty),
          onChanged: (value) {
            setState(() {
              if (value != null && value) {
                widget.faculties.add(faculty);
              } else {
                widget.faculties.remove(faculty);
              }
            });
          });
    }));
  }
}
