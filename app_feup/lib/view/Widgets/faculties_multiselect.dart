import 'package:flutter/material.dart';
import 'package:uni/view/Widgets/faculties_selection_form.dart';

class FacultiesMultiselect extends StatelessWidget {
  final faculties;
  final Function setFaculties;
  final Brightness brightness;

  FacultiesMultiselect(this.faculties, this.setFaculties, this.brightness);

  @override
  Widget build(BuildContext context) {
    final Color textColor = Color.fromARGB(255, 0xfa, 0xfa, 0xfa);

    return TextButton(
        child: createButtonContent(context),
        style: TextButton.styleFrom(
            primary: textColor,
            textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w300)
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return FacultiesSelectionForm(
                    List<String>.from(faculties), setFaculties, brightness
                );
              }
          );
        }
    );
  }

  Widget createButtonContent(BuildContext context) {
    Color borderColor;
    if (brightness == Brightness.dark) {
      borderColor = Colors.white;
    } else {
      borderColor = Colors.black;
    }

    return Container(
        child: Row(
            children: [
              Text('a(s) tua(s) faculdade(s)'),
              Spacer(),
              Icon(Icons.arrow_drop_down),
            ]
        ),
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 7),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                  color: borderColor,
                  width: 0.5,
                )
            )
        )
    );
  }
}
