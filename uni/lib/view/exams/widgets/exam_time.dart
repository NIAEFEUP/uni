import 'package:flutter/material.dart';

class ExamTime extends StatelessWidget {
  final String begin;

  const ExamTime({Key? key, required this.begin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Text(begin, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
