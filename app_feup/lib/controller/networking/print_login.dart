import 'package:http/http.dart' as http;

//Returns the cookie for print.up.pt
Future<String> printLogin(String studentNumber, String password) async {
  final url1 = 'https://print.up.pt/user';

  final getResponse = await http.get(Uri.parse(url1));

  final url = 'https://print.up.pt/app';

  final Map<String, String> headers = Map<String, String>();
  headers['content-type'] = 'application/x-www-form-urlencoded';
  headers['cookie'] = getResponse.headers['set-cookie'];
  headers['origin'] = 'https://print.up.pt';

  String payload =
      'service=direct%2F1%2FHome%2F%24Form&sp=S0&Form0=%24Hidden%240%2C%24Hidden%241%2CinputUsername%2CinputPassword%2C%24Submit%240%2C%24PropertySelection&%24Hidden%240=true&%24Hidden%241=X&%24Submit%240=Entrar&%24PropertySelection=pt_PT';
  final username = 'up${studentNumber}@up.pt';
  payload += '&inputUsername=${username}&inputPassword=${password}';

  final postResponse =
      await http.post(Uri.parse(url), headers: headers, body: payload);

  String cookie = postResponse.headers['set-cookie'];
  cookie = cookie.split('JSESSIONID=')[1];
  cookie = cookie.split(';')[0];

  return 'JSESSIONID=${cookie};';
}
