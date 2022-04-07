import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final String description;
  final String labelText;
  final String hintText;
  final String emptyText;
  final int minLines;
  final int maxLines;
  final double bottomMargin;
  final bool isOptional;
  final Function formatValidator;

  FormTextField(
    this.controller,
    this.icon, {
    this.description = '',
    this.minLines = 1,
    this.maxLines = 1,
    this.labelText = '',
    this.hintText = '',
    this.emptyText = 'Por favor preenche este campo',
    this.bottomMargin = 0,
    this.isOptional = false,
    this.formatValidator = null,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: bottomMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            description,
            style: Theme.of(context).textTheme.bodyText2,
            textAlign: TextAlign.left,
          ),
          Row(children: <Widget>[
            Container(
                margin: EdgeInsets.only(right: 15),
                child: Icon(
                  icon,
                  color: Theme.of(context).accentColor,
                )),
            Expanded(
                child: TextFormField(
              // margins
              minLines: minLines,
              maxLines: maxLines,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).accentColor),
                ),
                hintText: hintText,
                hintStyle: Theme.of(context).textTheme.bodyText2,
                labelText: labelText,
                labelStyle: Theme.of(context).textTheme.bodyText2,
              ),
              controller: controller,
              validator: (value) {
                if (value.isEmpty) {
                  return isOptional ? null : emptyText;
                }
                return formatValidator != null ? formatValidator(value) : null;
              },
            ))
          ])
        ],
      ),
    );
  }
}
