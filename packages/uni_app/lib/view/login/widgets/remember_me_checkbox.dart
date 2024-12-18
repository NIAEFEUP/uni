import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';

class RememberMeCheckBox extends StatelessWidget {
  const RememberMeCheckBox({
    required this.keepSignedIn,
    required this.onToggle,
    this.textColor,
    required this.padding,
    required this.theme,
    super.key,
  });

  final bool keepSignedIn;
  final VoidCallback onToggle;
  final Color? textColor;
  final EdgeInsets padding;
  final TextStyle? theme;

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
            side: const BorderSide(
              color: Color(0xFF56272B),
            ),
            fillColor: WidgetStateProperty.all(const Color(0xFF3C0A0E)),
            checkColor: const Color(0xFFFFF5F3),

          ),
          Text(
            S.of(context).keep_login,
            style: theme,
          ),
        ],
      ),
    );
  }
}
