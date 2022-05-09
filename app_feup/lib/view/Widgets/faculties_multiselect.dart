import 'package:flutter/material.dart';
import 'package:uni/view/Widgets/faculties_selection_form.dart';

class FacultiesMultiselect extends StatelessWidget {
  final userFaculties;
  final Function callback;

  FacultiesMultiselect(this.userFaculties, this.callback);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        child: Container(
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
                      color: Colors.black,
                      width: 0.5,
                    )
                )
            )
        ),
        style: TextButton.styleFrom(
            primary: Theme.of(context).primaryColor,
            textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w300)
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return FacultiesSelectionForm(
                    List<String>.from(userFaculties), callback
                );
              }
          );
        }
    );
  }
}
