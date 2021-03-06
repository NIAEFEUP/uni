import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

enum FormTextFieldValidator { none, email }

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
  final FormTextFieldValidator validatorType;

  FormTextField(
    this.controller,
    this.icon, {
    this.description = '',
    this.minLines = 1,
    this.maxLines = 1,
    this.labelText = '',
    this.hintText = '',
    this.emptyText = 'Por favor preenche corretamente este campo',
    this.bottomMargin = 0,
    this.isOptional = false,
    this.validatorType = FormTextFieldValidator.none,
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
            style: Theme.of(context).textTheme.body1,
            textAlign: TextAlign.left,
          ),
          Row(children: <Widget>[
            Container(
                margin: EdgeInsets.only(right: 15),
                child: Icon(
                  icon,
                  color: Theme.of(context).primaryColor,
                )),
            Expanded(
                child: TextFormField(
              // margins
              minLines: minLines,
              maxLines: maxLines,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: Theme.of(context).textTheme.body1,
                labelText: labelText,
                labelStyle: Theme.of(context).textTheme.body1,
              ),
              controller: controller,
              validator: (value) {
                if (value.isEmpty) {
                  return isOptional ? null : emptyText;
                }
                switch (validatorType) {
                  case FormTextFieldValidator.email:
                    return EmailValidator.validate(value) ? null : emptyText;
                  default:
                    return null;
                }
              },
            ))
          ])
        ],
      ),
    );
  }
}
