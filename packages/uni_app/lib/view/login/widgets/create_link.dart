import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:uni_ui/theme.dart';

class LinkWidget extends StatelessWidget {
  const LinkWidget({
    required this.textStart,
    required this.textEnd,
    required this.recognizer,
    super.key,
  });

  final String textStart;
  final String textEnd;
  final GestureRecognizer recognizer;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: textStart,
        style: lightTheme.textTheme.bodyMedium?.copyWith(
          color: Colors.white,
        ),
        children: [
          const TextSpan(text: ' '),
          TextSpan(
            text: textEnd,
            style: lightTheme.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              decoration: TextDecoration.underline,
              decorationColor: Colors.white,
            ),
            recognizer: recognizer,
          ),
        ],
      ),
    );
  }
}
