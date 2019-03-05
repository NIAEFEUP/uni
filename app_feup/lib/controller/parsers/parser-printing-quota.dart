import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;


Future<String> printingQuotaGet(http.Response response) async {

  var document = parse(response.body);

  var element = document.querySelector('.info');

  String s = element.text;

  var i = s.indexOf(':');

  if (i == -1)
    return '';

  s = s.substring(i+2);

  return s;
}

// To use
// printingQuotaGet(await NetworkRouter.getWithCookies("https://sigarra.up.pt/feup/pt/imp4_impressoes.atribs?p_codigo=${store.state.content['session']['studentNumber']}"));


