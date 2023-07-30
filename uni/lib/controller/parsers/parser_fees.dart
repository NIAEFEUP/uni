import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;

/// Extracts the balance of the user's account from an HTTP [response].
String parseFeesBalance(http.Response response) {
  final document = parse(response.body);
  final balanceString = document.querySelector('span#span_saldo_total')?.text;
  return '$balanceString €';
}

/// Extracts the user's payment due date from an HTTP [response].
///
/// If there are no due payments, `Sem data` is returned.
DateTime? parseFeesNextLimit(http.Response response) {
  final document = parse(response.body);
  final lines = document.querySelectorAll('#tab0 .tabela tr');

  try {
    final limit = lines[1].querySelectorAll('.data')[0].text;
    return DateTime.parse(limit);
  } catch (_) {
    return null;
  }
}
