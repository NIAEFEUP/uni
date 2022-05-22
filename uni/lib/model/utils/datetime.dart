import 'package:intl/intl.dart';

String readableTime(DateTime time) {
  final hours = DateFormat('HH').format(time);
  final minutes = DateFormat('mm').format(time);
  return hours + 'h' + minutes;
}