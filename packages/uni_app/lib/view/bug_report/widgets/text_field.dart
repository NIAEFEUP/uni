import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';

class FormTextField extends StatelessWidget {
  const FormTextField(
    this.controller,
    this.icon, {
    this.description = '',
    this.minLines = 1,
    this.maxLines = 1,
    this.labelText = '',
    this.hintText = '',
    this.emptyText = '',
    this.bottomMargin = 0,
    this.isOptional = false,
    this.formatValidator,
    super.key,
  });

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
  final String? Function(String?)? formatValidator;

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
          Row(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(right: 15),
                child: Icon(
                  icon,
                ),
              ),
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
                    if (value == null || value.isEmpty) {
                      return isOptional ? null : S.of(context).empty_text;
                    }
                    return formatValidator?.call(value);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
