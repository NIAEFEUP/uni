import 'package:http/http.dart' as http;
import 'package:uni/controller/networking/network_router.dart';

class PrintService {
  static const String printUrl = 'https://print.up.pt';

  /// Returns the cookie for print.up.pt service
  static Future<String> getCookie(String studentNumber, String password) async {
    const url1 = '$printUrl/user';

    final getResponse =
        await http.get(Uri.parse(url1)).timeout(const Duration(seconds: 5));

    const url = '$printUrl/app';

    final Map<String, String> headers = <String, String>{};
    headers['content-type'] = 'application/x-www-form-urlencoded';
    headers['origin'] = printUrl;
    headers['cookie'] = getResponse.headers['set-cookie'] ?? '';
    if (headers['cookie'] == '') throw Exception('No cookie header found!');

    final email = 'up$studentNumber@up.pt';

    final Map<String, String> payload = <String, String>{
      'service': 'direct/1/Home/\$Form',
      'sp': 'S0',
      'Form0':
          '\$Hidden\$0,\$Hidden\$1,inputUsername,inputPassword,\$Submit\$0,\$PropertySelection',
      '\$Hidden\$0': 'true',
      '\$Hidden\$1': 'X',
      '\$Submit\$0': 'Entrar',
      '\$PropertySelection': 'pt_PT',
      'inputUsername': email,
      'inputPassword': password,
    };

    //Map to urlencoded string
    final String payloadString = NetworkRouter.urlEncodeMap(payload);

    final postResponse =
        await http.post(Uri.parse(url), headers: headers, body: payloadString);

    String cookie = postResponse.headers['set-cookie'] ?? '';
    cookie = cookie.split('JSESSIONID=')[1];
    cookie = cookie.split(';')[0];
    if (cookie == '') throw Exception('No cookie found!');

    return 'JSESSIONID=$cookie;';
  }
}
