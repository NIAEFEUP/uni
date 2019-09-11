
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BugPageTextWidget extends StatelessWidget {

  final TextEditingController controller;
  final IconData icon;
  final String description;
  final String labelText;
  final String hintText;
  final String emptyText;
  final int minLines;
  final int maxLines;
  final double bottomMargin;

  BugPageTextWidget(
      TextEditingController controller,
      IconData icon,
      {
        String description = "",
        int minLines = 1,
        int maxLines = 1,
        String labelText = "",
        String hintText = "",
        String emptyText = "Por favor escreve algo",
        double bottomMargin = 0,
      }
      ) : controller=controller,
          icon=icon,
          description=description,
          minLines=minLines,
          maxLines=maxLines,
          labelText=labelText,
          emptyText=emptyText,
          hintText=hintText,
          bottomMargin=bottomMargin {}

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.only(bottom: bottomMargin),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            description,
            style: Theme.of(context).textTheme.body1,
            textAlign: TextAlign.left,
          ),
          new Row(
              children: <Widget>[
                new Container(
                    margin: new EdgeInsets.only(right:15),
                    child: new Icon(icon)
                ),
                Expanded(
                    child: new TextFormField(
                      // margins
                      minLines: minLines,
                      maxLines: maxLines,
                      decoration: InputDecoration(
                        hintText: hintText,
                        labelText: labelText,
                      ),
                      controller: controller,
                      validator: (value) {
                        if (value.isEmpty) {
                          return emptyText;
                        }
                        return null;
                      },
                    )
                )
              ]
          )
        ],
      ),

    );
  }
}
