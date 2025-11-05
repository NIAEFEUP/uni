import 'package:flutter/widgets.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni_ui/theme.dart';

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
    return Container(
      margin: EdgeInsets.only(bottom: bottomMargin),
      child: TextFormField(
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        minLines: minLines,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryVibrant),
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Theme.of(context).primaryVibrant),
          ),
        ),
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
