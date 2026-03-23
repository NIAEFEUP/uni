import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;

List<Map<String, String>> parseProfileDetails(http.Response response) {
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
    if (table.length.isOdd) {
      table.removeLast();
    }
    for (var i = 0; i < table.length; i += 2) {
      final key = table[i];
      final value = table[i + 1];
      final cleanedKey = key.endsWith(':')
          ? key.substring(0, key.length - 1)
          : key;
      tableWithPairs.add([cleanedKey, value]);
    }

    eachTable.add(tableWithPairs);
  }

  final List<Map<String, String>> result = [];

  for (final tableInList in eachTable) {
    final tableInMap = {
      for (final element in tableInList) element[0]: element[1],
    };
    result.add(tableInMap);
  }

  return result;
}
