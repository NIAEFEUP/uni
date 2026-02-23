import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;

List<List<List<String>>> parseProfileDetails(http.Response response) {
  final document = parse(response.body);
  final tables = document.querySelectorAll('table');
  final List<List<List<String>>> eachTable = [];

  for (final tableRaw in tables) {
    final table = tableRaw
        .querySelectorAll('td')
        .map((cell) => cell.text.trim().replaceAll(':', ''))
        .where((cell) => cell.isNotEmpty)
        .toList();
    final List<List<String>> tableWithPairs = [];
    for (var i = 0; i < table.length; i += 2) {
      tableWithPairs.add(table.sublist(i, i + 2));
    }

    eachTable.add(tableWithPairs);
  }

  return eachTable;
}
