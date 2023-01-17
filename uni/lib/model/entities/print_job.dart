import 'package:intl/intl.dart';

class PrintJob {
  final String filename;
  final DateTime datetime;
  final double cost;
  final int pages;
  final String size;
  final bool colors;
  final String _cancelUrl;

  static String printURL = "https://print.up.pt";

  String get cancelUrl => printURL + _cancelUrl;

  PrintJob(this.filename, this.datetime, this.cost, this.pages, this.size,
      this.colors, this._cancelUrl);

  /// Creates a new instance from a JSON object.
  static PrintJob fromParser(
      filename, datetime, cost, pages, printer, cancelUrl) {
    final List splitedPrinter = printer.split('-');
    final bool colors = splitedPrinter[2] == 'C';
    final String size = splitedPrinter[3];

    return PrintJob(
      filename,
      DateFormat('MMM dd, yyyy h:mm:ss a')
          .parse(datetime), //datetime example: "Nov 8, 2022 3:17:39 PM"
      double.parse(cost.replaceAll(',', '.')),
      int.parse(pages),
      size,
      colors,
      cancelUrl,
    );
  }

  /// Creates a new instance from a JSON object
  PrintJob.fromJson(Map<String, dynamic> json)
      : filename = json['filename'],
        datetime = DateFormat('dd/MM/yyyy HH:mm').parse(json['datetime']),
        cost = double.parse(json['cost']),
        pages = int.parse(json['pages']),
        size = json['size'],
        colors = json['colors'] == 'true',
        _cancelUrl = json['cancelUrl'];

  /// Converts this print release to a map
  Map<String, dynamic> toMap() {
    final DateFormat format = DateFormat('dd/MM/yyyy HH:mm');
    return {
      'filename': filename,
      'datetime': format.format(datetime),
      'cost': cost,
      'pages': pages,
      'size': size,
      'colors': colors,
      'cancelUrl': _cancelUrl,
    };
  }
}
