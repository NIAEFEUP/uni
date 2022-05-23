extension TimeString on DateTime {
  String toTimeHourMinString() {
    return this.hour.toString().padLeft(2, '0') +
        ':' +
        this.minute.toString().padLeft(2, '0');
  }
}
