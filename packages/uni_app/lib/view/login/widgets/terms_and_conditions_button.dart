import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/view/about/widgets/terms_and_conditions.dart';
import 'package:uni_ui/theme.dart';

class TermsAndConditionsButton extends StatelessWidget {
  const TermsAndConditionsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.fromLTRB(40, 14, 40, 14),
        child: RichText(
          text: TextSpan(
            text: S.of(context).agree_terms,
            style: lightTheme.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              decorationColor: Colors.white,
            ),
            children: [
              const TextSpan(
                text: ' ',
              ),
              TextSpan(
                text: S.of(context).terms,
                style: lightTheme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    _showTermsAndConditions(context);
                  },
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Future<void> _showTermsAndConditions(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(S.of(context).terms),
          content: const SingleChildScrollView(child: TermsAndConditions()),
          actions: <Widget>[
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
