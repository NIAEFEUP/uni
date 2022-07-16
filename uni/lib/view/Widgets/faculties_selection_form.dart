import 'package:flutter/material.dart';
import 'package:uni/utils/constants.dart' as constants;

class FacultiesSelectionForm extends StatefulWidget {
  final List<String> faculties;
  final Function setFaculties;

  const FacultiesSelectionForm(this.faculties, this.setFaculties, {super.key});

  @override
  State<StatefulWidget> createState() => _FacultiesSelectionFormState();
}

class _FacultiesSelectionFormState extends State<FacultiesSelectionForm> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: const Color.fromARGB(255, 0x75, 0x17, 0x1e),
        title: const Text('seleciona a(s) tua(s) faculdade(s)'),
        titleTextStyle: const TextStyle(
            color: Color.fromARGB(255, 0xfa, 0xfa, 0xfa), fontSize: 18),
        content: SizedBox(
            height: 500.0, width: 200.0, child: createCheckList(context)),
        actions: createActionButtons(context));
  }

  List<Widget> createActionButtons(BuildContext context) {
    return [
      TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar', style: TextStyle(color: Colors.white))),
      ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Theme.of(context).primaryColor),
          onPressed: () {
            Navigator.pop(context);
            widget.setFaculties(widget.faculties);
          },
          child: const Text('Confirmar'))
    ];
  }

  Widget createCheckList(BuildContext context) {
    return ListView(
        children: List.generate(constants.faculties.length, (i) {
      final String faculty = constants.faculties.elementAt(i);
      return CheckboxListTile(
          title: Text(faculty.toUpperCase(),
              style: const TextStyle(
                  color: Color.fromARGB(255, 0xfa, 0xfa, 0xfa),
                  fontSize: 20.0)),
          activeColor: const Color.fromARGB(255, 0x75, 0x17, 0x1e),
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
