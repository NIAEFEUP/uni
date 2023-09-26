import 'package:flutter/material.dart';

class ExamTitle extends StatelessWidget {
  const ExamTitle({
    required this.subject,
    this.type,
    this.reverseOrder = false,
    super.key,
  });
  static const double borderRadius = 12;
  static const double sideSizing = 12;
  final String subject;
  final String? type;
  final bool reverseOrder;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: createTopRectangle(context),
    );
  }

  Widget createTopRectangle(BuildContext context) {
    final typeWidget = Text(
      type != null ? ' ($type) ' : '',
      style: Theme.of(context).textTheme.bodyMedium,
    );
    final subjectWidget = Text(
      subject,
      style: Theme.of(context)
          .textTheme
          .headlineSmall
          ?.apply(color: Theme.of(context).colorScheme.tertiary),
    );

    return Row(
      children: reverseOrder
          ? [typeWidget, subjectWidget]
          : [subjectWidget, typeWidget],
    );
  }
}
