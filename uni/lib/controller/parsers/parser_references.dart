import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:uni/model/entities/reference.dart';


/// Extracts a list of references from an HTTP [response].
Future<List<Reference>> parseReferences(http.Response response) async {
  final document = parse(response.body);

  final List<Reference> references = [];

  final List<Element> rows = document
      .querySelectorAll('div#tab0 > table.dadossz > tbody > tr');

  if (rows.length > 1) {
    rows.sublist(1)
        .forEach((Element tr) {
      final List<Element> info = tr.querySelectorAll('td');
      final String description = info[0].text;
      final DateTime limitDate = DateTime.parse(info[2].text);
      final int entity = int.parse(info[3].text);
      final int reference = int.parse(info[4].text);
      final String formattedAmount = info[5].text
          .replaceFirst(',', '.')
          .replaceFirst('€', '');
      final double amount = double.parse(formattedAmount);
      references.add(Reference(description, limitDate, entity, reference, amount));
    });
  }

  return references;
}