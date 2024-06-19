import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:uni/model/entities/reference.dart';

/// Extracts a list of references from an HTTP [response].
Future<List<Reference>> parseReferences(http.Response response) async {
  final document = parse(response.body);

  final references = <Reference>[];

  final rows =
      document.querySelectorAll('div#tab0 > table.dadossz > tbody > tr');

  if (rows.length > 1) {
    rows.sublist(1).forEach((tr) {
      final info = tr.querySelectorAll('td');
      final description = info[0].text;
      final limitDate = DateTime.parse(info[2].text);
      final entity = int.parse(info[3].text);
      final reference = int.parse(info[4].text);
      final formattedAmount =
          info[5].text.replaceFirst(',', '.').replaceFirst('€', '');
      final amount = double.parse(formattedAmount);
      references
          .add(Reference(description, limitDate, entity, reference, amount));
    });
  }

  return references;
}
