extension TimeString on DateTime {
  String toTimeString() {
    return this.hour.toString().padLeft(2, '0') +
        ':' +
        this.minute.toString().padLeft(2, '0');
  }
}