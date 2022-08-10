extension TimeString on DateTime {
  String toTimeHourMinString() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}
