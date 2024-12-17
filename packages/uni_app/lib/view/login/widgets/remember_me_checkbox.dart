import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';

class RememberMeCheckBox extends StatelessWidget {
  const RememberMeCheckBox({
    required this.keepSignedIn,
    required this.onToggle,
    this.textColor,
    required this.padding,
    super.key,
  });

  final bool keepSignedIn;
  final VoidCallback onToggle;
  final Color? textColor;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Checkbox(
            value: keepSignedIn,
            onChanged: (_) => onToggle(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          Text(
            S.of(context).keep_login,
            style: TextStyle(
              color: textColor ?? Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
