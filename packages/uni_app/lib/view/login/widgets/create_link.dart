import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

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
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Colors.white,
              fontSize: 14,
            ),
        children: [
          const TextSpan(text: ' '),
          TextSpan(
            text: textEnd,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white,
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
