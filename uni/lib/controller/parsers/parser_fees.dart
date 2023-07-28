import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;

/// Extracts the balance of the user's account from an HTTP [response].
String parseFeesBalance(http.Response response) {
  final document = parse(response.body);
  final balanceString = document
      .querySelector('span#span_saldo_total')
      ?.text;
  return '$balanceString €';
}

/// Extracts the user's payment due date from an HTTP [response].
///
/// If there are no due payments, `Sem data` is returned.
DateTime? parseFeesNextLimit(http.Response response) {
  final document = parse(response.body);

  final lines = document.querySelectorAll('#tab0 .tabela tr');

  if (lines.length < 2) {
    return null;
  }

  final limit = lines[1].querySelectorAll('.data')[1].text;

  // It's completely fine to throw an exception if it fails, in this case,
  // since probably Sigarra is returning something we don't except
  return DateTime.parse(limit);
}
