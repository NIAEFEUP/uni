import 'package:intl/intl.dart';

String readableTime(DateTime time) {
  return DateFormat("H'h'mm").format(time);
}