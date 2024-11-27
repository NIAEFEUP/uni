import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';

class RememberMeCheckBox extends StatelessWidget {

  const RememberMeCheckBox({
    required this.keepSignedIn,
    required this.onToggle,
    this.textColor,
    super.key,
  });

  final bool keepSignedIn;
  final VoidCallback onToggle;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: keepSignedIn,
      onChanged: (_) => onToggle(),
      title: Text(
        S.of(context).keep_login,
        textAlign: TextAlign.left,
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w300,
        ),
      ),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: const EdgeInsets.symmetric(horizontal: 36),
      checkboxShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}
