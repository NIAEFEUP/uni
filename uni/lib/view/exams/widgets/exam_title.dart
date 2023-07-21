import 'package:flutter/material.dart';

class ExamTitle extends StatelessWidget {

  const ExamTitle(
      {super.key, required this.subject, this.type, this.reverseOrder = false,});
  final String subject;
  final String? type;
  final double borderRadius = 12;
  final double sideSizing = 12;
  final bool reverseOrder;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: createTopRectangle(context),
    );
  }

  Widget createTopRectangle(context) {
    final typeWidget = Text(type != null ? ' ($type) ' : '',
        style: Theme.of(context).textTheme.bodyMedium,);
    final subjectWidget = Text(subject,
        style: Theme.of(context)
            .textTheme
            .headlineSmall
            ?.apply(color: Theme.of(context).colorScheme.tertiary),);

    return Row(
        children: reverseOrder
            ? [typeWidget, subjectWidget]
            : [subjectWidget, typeWidget],);
  }
}
