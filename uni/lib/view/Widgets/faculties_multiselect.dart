import 'package:flutter/material.dart';
import 'package:uni/view/Widgets/faculties_selection_form.dart';

class FacultiesMultiselect extends StatelessWidget {
  final List<String> faculties;
  final Function setFaculties;
  final Brightness brightness;

  const FacultiesMultiselect(this.faculties, this.setFaculties, this.brightness,
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
                    List<String>.from(faculties), setFaculties, brightness);
              });
        },
        child: createButtonContent(context));
  }

  Widget createButtonContent(BuildContext context) {
    Color borderColor;
    if (brightness == Brightness.dark) {
      borderColor = Colors.white;
    } else {
      borderColor = Colors.black;
    }

    return Container(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 7),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
          color: borderColor,
          width: 0.5,
        ))),
        child: Row(children: const [
          Text('a(s) tua(s) faculdade(s)'),
          Spacer(),
          Icon(Icons.arrow_drop_down),
        ]));
  }
}
