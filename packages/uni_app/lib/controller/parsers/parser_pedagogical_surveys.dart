import 'package:html/parser.dart';
import 'package:http/http.dart';

bool parsePedagogicalSurveys(List<Response> coursesResponses) {
  if (coursesResponses.isEmpty) {
    return true;
  }

  for (final response in coursesResponses) {
    final document = parse(response.body);

    final surveys = document
        .querySelectorAll('[href]')
        .where(
          (el) =>
              el.attributes['href'] != null &&
              el.attributes['href']!.contains('ipup2016_geral.ipup_inicio'),
        );
    if (surveys.isNotEmpty) {
      return false;
    }
  }
  return true;
}
