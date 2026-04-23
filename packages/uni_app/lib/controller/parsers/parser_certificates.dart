import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;
import 'package:uni/model/entities/certificate.dart';

final _deliveredDateRegex = RegExp(r'\((\d{4}-\d{2}-\d{2})\)');
final _dateFromTextRegex = RegExp(r'(\d{4}-\d{2}-\d{2})');

List<Certificate> parseCertificates(http.Response response,
    {required String baseUrl}) {
  final document = html_parser.parse(response.body);
  final rows = document.querySelectorAll('tr').where((row) {
    final cells = row.querySelectorAll('td');
    return cells.length >= 4 &&
        row.querySelector('a[href*="PED_CERT_VIEW"]') != null;
  });

  return rows.map((row) {
    final cells = row.querySelectorAll('td');
    final typeCell = cells.isNotEmpty ? cells[0] : null;
    final requestedCell = cells.length > 1 ? cells[1] : null;
    final processedCell = cells.length > 2 ? cells[2] : null;
    final resultCell = cells.length > 3
        ? cells[3]
        : (cells.isNotEmpty ? cells.last : null);
    final typeLink = typeCell?.querySelector('a');

    final resultText = resultCell?.text.replaceAll(RegExp(r'\s+'), ' ').trim() ?? '';
    final deliveredOn = _extractDeliveredDate(resultText);

    final downloadLink =
        resultCell?.querySelector('a[href*="download_ficheiro"]') ??
        row.querySelector('a[href*="download_ficheiro"]');

    return Certificate(
      type: typeLink?.text.trim() ?? cells[0].text.trim(),
      detailUrl: _resolveUrl(baseUrl, typeLink?.attributes['href']),
      requestedOn: _parseDate(requestedCell),
      requested: _isCompletedStatus(requestedCell),
      processed: _isCompletedStatus(processedCell),
      result: resultText,
      deliveredOn: deliveredOn,
      downloadUrl: _resolveUrl(baseUrl, downloadLink?.attributes['href']),
      status: _statusFromRow(row),
    );
  }).toList();
}

bool isCertificatesPage(http.Response response) {
  final document = html_parser.parse(response.body);
  final hasCertificatesTable = document.querySelector(
          '#conteudoinner table.dados, #conteudoinner table.dadossz') !=
      null;
  final hasCertificatesRows =
      document.querySelector('a[href*="PED_CERT_VIEW"]') != null;
  return hasCertificatesTable || hasCertificatesRows;
}

DateTime? _extractDeliveredDate(String resultText) {
  final date = _deliveredDateRegex.firstMatch(resultText)?.group(1);
  return date == null ? null : DateTime.tryParse(date);
}

DateTime? _parseDate(dom.Element? cell) {
  if (cell == null) {
    return null;
  }

  final title = cell.attributes['title'];
  final parsedTitle = title == null ? null : DateTime.tryParse(title);
  if (parsedTitle != null) {
    return parsedTitle;
  }

  final dateFromText = _dateFromTextRegex.firstMatch(cell.text)?.group(1);
  return dateFromText == null ? null : DateTime.tryParse(dateFromText);
}

CertificateStatus _statusFromRow(dom.Element row) {
  final resultCell = row.querySelector('td.result-pronto, td.result-anulado') ??
      (row.querySelectorAll('td').length > 3
          ? row.querySelectorAll('td')[3]
          : null);

  final classes = resultCell?.classes ?? const <String>{};
  if (classes.contains('result-anulado')) {
    return CertificateStatus.cancelled;
  }

  if (classes.contains('result-pronto')) {
    return CertificateStatus.delivered;
  }

  if (row.querySelector('a[href*="download_ficheiro"]') != null) {
    return CertificateStatus.delivered;
  }

  return CertificateStatus.pending;
}

bool _isCompletedStatus(dom.Element? cell) {
  if (cell == null) {
    return false;
  }

  final image = cell.querySelector('img');
  if (image == null) {
    return false;
  }

  final src = image.attributes['src'] ?? '';
  return src.contains('CERT-Visto');
}

Uri? _resolveUrl(String baseUrl, String? url) {
  if (url == null || url.isEmpty) {
    return null;
  }

  final baseUri = Uri.parse(baseUrl);
  return baseUri.resolve(url);
}
