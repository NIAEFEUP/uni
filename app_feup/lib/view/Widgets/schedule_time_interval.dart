import 'package:flutter/material.dart';

class ScheduleTimeInterval extends StatelessWidget {
  final String begin;
  final String end;
  ScheduleTimeInterval({Key key, @required this.begin, @required this.end})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Text(this.begin,
            style:
                Theme.of(context).textTheme.headline4.apply(fontSizeDelta: -3)),
        Text(this.end,
            style:
                Theme.of(context).textTheme.headline4.apply(fontSizeDelta: -3)),
      ],
    );
  }
}
