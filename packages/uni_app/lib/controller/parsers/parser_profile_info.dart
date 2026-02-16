import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;


List<String> parseProfileDetails(http.Response response) {
  final document = parse(response.body);
  final tables = document.querySelectorAll('td');
  final cellTexts = tables.map((cell) => cell.text.trim()).toList();
  final utilInfo = cellTexts.where((i) => i.isNotEmpty && !i.contains(':')).toList();
  
  return utilInfo;
}