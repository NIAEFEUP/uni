import 'package:flutter/material.dart';
import 'package:uni/view/login/widgets/faculties_selection_form.dart';
import 'package:uni/generated/l10n.dart';

class FacultiesMultiselect extends StatelessWidget {
  final List<String> selectedFaculties;
  final Function setFaculties;

  const FacultiesMultiselect(this.selectedFaculties, this.setFaculties,
      {super.key});

  @override
  Widget build(BuildContext context) {
    const Color textColor = Color.fromARGB(255, 0xfa, 0xfa, 0xfa);

    return TextButton(
        style: TextButton.styleFrom(
            textStyle: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.w300, color: textColor)),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return FacultiesSelectionForm(
                    List<String>.from(selectedFaculties), setFaculties);
              });
        },
        child: _createButtonContent(context));
  }

  Widget _createButtonContent(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 7),
        decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(
          color: Colors.white,
          width: 1,
        ))),
        child: Row(children: [
          Expanded(
            child: Text(
              _facultiesListText(context),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const Icon(
            Icons.arrow_drop_down,
            color: Colors.white,
          ),
        ]));
  }

  String _facultiesListText(BuildContext context) {
    if (selectedFaculties.isEmpty) {
      return S.of(context).no_college;
    }
    String facultiesText = '';
    for (String faculty in selectedFaculties) {
      facultiesText += '${faculty.toUpperCase()}, ';
    }
    return facultiesText.substring(0, facultiesText.length - 2);
  }
}
