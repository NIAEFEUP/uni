import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScheduleEventRectangle extends StatelessWidget {
  final String subject;
  final String type;
  final double borderRadius = 12.0;
  final double sideSizing = 12.0;
  final bool reverseOrder;

  ScheduleEventRectangle(
      {Key key, @required this.subject, this.type, this.reverseOrder = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: this.createTopRectangle(context),
    );
  }

  Widget createTopRectangle(context) {
    final Text typeWidget = Text(this.type != null ? ' (${type}) ' : '',
        style: Theme.of(context).textTheme.bodyText2);
    final Text subjectWidget = Text(this.subject,
        style: Theme.of(context)
            .textTheme
            .headline5
            .apply(color: Theme.of(context).accentColor));

    return Row(
        children: (reverseOrder
            ? [typeWidget, subjectWidget]
            : [subjectWidget, typeWidget]));
  }
}
