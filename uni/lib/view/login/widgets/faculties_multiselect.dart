import 'package:flutter/material.dart';
import 'package:uni/view/login/widgets/faculties_selection_form.dart';

class FacultiesMultiselect extends StatelessWidget {
  const FacultiesMultiselect(
    this.selectedFaculties,
    this.setFaculties, {
    super.key,
  });
  final List<String> selectedFaculties;
  final Function setFaculties;

  @override
  Widget build(BuildContext context) {
    const textColor = Color.fromARGB(255, 0xfa, 0xfa, 0xfa);

    return TextButton(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w300,
          color: textColor,
        ),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return FacultiesSelectionForm(
              List<String>.from(selectedFaculties),
              setFaculties,
            );
          },
        );
      },
      child: _createButtonContent(context),
    );
  }

  Widget _createButtonContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 7),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _facultiesListText(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const Icon(
            Icons.arrow_drop_down,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  String _facultiesListText() {
    if (selectedFaculties.isEmpty) {
      return 'sem faculdade';
    }
    var facultiesText = '';
    for (final faculty in selectedFaculties) {
      facultiesText += '${faculty.toUpperCase()}, ';
    }
    return facultiesText.substring(0, facultiesText.length - 2);
  }
}
