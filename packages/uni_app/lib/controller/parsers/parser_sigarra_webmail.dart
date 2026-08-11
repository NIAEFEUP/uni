import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:uni/model/entities/dynamic_webmail.dart';

List<MailAttachment> parseMailAttachments(http.Response response) {
  final document = parse(response.body);
  final attachments = <MailAttachment>[];

  final rows = document.querySelectorAll('table.tabela tbody tr');

  for (final row in rows) {
    final cells = row.querySelectorAll('td');

    if (cells.length < 4) {
      continue;
    }

    final link = cells[0].querySelector('a');
    final fileName = link?.text.trim() ?? '';
    final downloadUrl = link?.attributes['href'] ?? '';

    final size = cells[1].text.trim();
    final subject = cells[2].text.trim();
    final dateText = cells[3].text.trim();

    if (fileName.isEmpty || downloadUrl.isEmpty) {
      continue;
    }

    final date = DateTime.tryParse(dateText);

    if (date == null) {
      continue;
    }

    attachments.add(
      MailAttachment(
        fileName: fileName,
        subject: subject,
        size: size,
        downloadUrl: downloadUrl,
        date: date,
      ),
    );
  }

  return attachments;
}
