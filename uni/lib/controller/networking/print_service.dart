import 'package:http/http.dart' as http;
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/entities/session.dart';

class PrintService {
  static const String printUrl = 'https://print.up.pt';

  // Login into print.up.pt service
  Future login(Session session, String password) async {
    final String cookie = await _getCookie(session.studentNumber, password);
    session.cookies += cookie;
  }

  /// Returns the cookie for print.up.pt service
  Future<String> _getCookie(String username, String password) async {
    const url1 = '$printUrl/user';

    final getResponse =
        await http.get(Uri.parse(url1)).timeout(const Duration(seconds: 5));

    const url = '$printUrl/app';

    final Map<String, String> headers = <String, String>{};
    headers['content-type'] = 'application/x-www-form-urlencoded';
    headers['origin'] = printUrl;
    headers['cookie'] = getResponse.headers['set-cookie'] ?? '';
    if (headers['cookie'] == '') throw Exception('No cookie header found!');

    final email = getStudentEmail(username);

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

  /// returns the user email in up200000000@up.pt format
  String getStudentEmail(String username) {
    //Extracts only the number from username
    final regex = RegExp(r'\d+');
    final String? studentNumber = regex.stringMatch(username);
    if (studentNumber == null) throw Exception('No student number!');

    return 'up$studentNumber@up.pt';
  }

  static Future<bool> isLoggedIn(Session session) async {
    if (session.cookies.contains('JSESSIONID')) {
      const String url = '$printUrl/app?service=page/UserSummary';
      final http.Response response =
          await NetworkRouter.getWithCookies(url, {}, session);
      if (response.statusCode == 200) {
        return true;
      }
    }
    return false;
  }
}
