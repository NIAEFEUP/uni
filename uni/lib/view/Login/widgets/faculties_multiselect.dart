import 'package:flutter/material.dart';
import 'package:uni/view/Login/widgets/faculties_selection_form.dart';

class FacultiesMultiselect extends StatelessWidget {
  final List<String> faculties;
  final Function setFaculties;

  const FacultiesMultiselect(this.faculties, this.setFaculties, {super.key});

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
                    List<String>.from(faculties), setFaculties);
              });
        },
        child: createButtonContent(context));
  }

  Widget createButtonContent(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 7),
        decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(
          color: Colors.white,
          width: 1,
        ))),
        child: Row(children: const [
          Text(
            'a(s) tua(s) faculdade(s)',
            style: TextStyle(color: Colors.white),
          ),
          Spacer(),
          Icon(
            Icons.arrow_drop_down,
            color: Colors.white,
          ),
        ]));
  }
}
