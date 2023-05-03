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
  final Function? formatValidator;

  const FormTextField(this.controller, this.icon,
      {this.description = '',
      this.minLines = 1,
      this.maxLines = 1,
      this.labelText = '',
      this.hintText = '',
      this.emptyText = 'Por favor preenche este campo',
      this.bottomMargin = 0,
      this.isOptional = false,
      this.formatValidator,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: bottomMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.left,
          ),
          Row(children: <Widget>[
            Container(
                margin: const EdgeInsets.only(right: 15),
                child: Icon(
                  icon,
                )),
            Expanded(
                child: TextFormField(
              // margins
              minLines: minLines,
              maxLines: maxLines,
              decoration: InputDecoration(
                focusedBorder: const UnderlineInputBorder(),
                hintText: hintText,
                hintStyle: Theme.of(context).textTheme.bodyMedium,
                labelText: labelText,
                labelStyle: Theme.of(context).textTheme.bodyMedium,
              ),
              controller: controller,
              validator: (value) {
                if (value!.isEmpty) {
                  return isOptional ? null : emptyText;
                }
                return formatValidator != null ? formatValidator!(value) : null;
              },
            ))
          ])
        ],
      ),
    );
  }
}
