import 'package:flutter/material.dart';

class ExamTime extends StatelessWidget {
  const ExamTime({required this.begin, super.key});
  final String begin;

  @override
  Widget build(BuildContext context) {
    return Text(begin, style: Theme.of(context).textTheme.bodyMedium);
  }
}
