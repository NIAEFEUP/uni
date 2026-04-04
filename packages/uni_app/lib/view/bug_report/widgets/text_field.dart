import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni_ui/cards/generic_card.dart';

class FormTextField extends StatelessWidget {
  const FormTextField(
    this.controller, {
    this.description = '',
    this.minLines = 1,
    this.maxLines = 1,
    this.labelText = '',
    this.hintText = '',
    this.bottomMargin = 0,
    this.isOptional = false,
    this.formatValidator,
    super.key,
  });

  final TextEditingController controller;
  final String description;
  final String labelText;
  final String hintText;
  final int minLines;
  final int maxLines;
  final double bottomMargin;
  final bool isOptional;
  final String? Function(String?)? formatValidator;

  @override
  Widget build(BuildContext context) {
    return GenericCard(
      tooltip: description,
      margin: EdgeInsets.only(bottom: bottomMargin),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextFormField(
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        minLines: minLines,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: labelText + (isOptional ? '' : ' *'),
          hintText: hintText,
          labelStyle: Theme.of(context).textTheme.titleLarge,
          hintStyle: Theme.of(context).textTheme.bodyMedium,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: InputBorder.none,
        ),
        cursorColor: Theme.of(context).colorScheme.onSecondaryContainer,
        style: Theme.of(context).textTheme.bodyMedium,
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return isOptional ? null : S.of(context).empty_text;
          }
          return formatValidator?.call(value);
        },
      ),
    );
  }
}
