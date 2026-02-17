import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;


List<List<String>> parseProfileDetails(http.Response response) {
  final document = parse(response.body);
  final tables = document.querySelectorAll('td');
  final cellTexts = tables.map((cell) => cell.text.trim()).toList();
  final utilInfo = cellTexts.where((i) => i.isNotEmpty && !i.contains(':')).toList();
  final prefixes = cellTexts.where((i) => i.isNotEmpty && i.contains(':')).map((i) => i.replaceAll(':', '')).toList();
  
  return [utilInfo, prefixes];
}
