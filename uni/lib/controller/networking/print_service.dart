import 'package:http/http.dart' as http;
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/entities/session/print_service_session.dart';

class PrintService {
  static const String printUrl = 'https://print.up.pt';

  /// Returns the cookie for print.up.pt service
  static Future<String> getCookie(String email, String password) async {
    const url1 = '$printUrl/user';

    final getResponse =
        await http.get(Uri.parse(url1)).timeout(const Duration(seconds: 5));

    if (getResponse.statusCode != 200) throw Exception('Error getting cookie');

    const url = '$printUrl/app';

    final Map<String, String> headers = <String, String>{};
    headers['content-type'] = 'application/x-www-form-urlencoded';
    headers['origin'] = printUrl;
    headers['cookie'] = getResponse.headers['set-cookie'] ?? '';
    if (headers['cookie'] == '') throw Exception('No cookie header found!');

    final Map<String, String> payload = <String, String>{
      'service': 'direct/1/Home/\$Form',
      'sp': 'S0',
      'Form0': '\$Hidden\$0,\$Hidden\$1,inputUsername,inputPassword,\$Submit\$0,\$PropertySelection',
      '\$Hidden\$0': 'true',
      '\$Hidden\$1': 'X',
      'inputUsername': email,
      'inputPassword': password,
      '\$Submit\$0': 'Log+in',
      '\$PropertySelection': 'en',
    };

    //Map to urlencoded string
    final String payloadString = NetworkRouter.urlEncodeMap(payload);

    final postResponse =
        await http.post(Uri.parse(url), headers: headers, body: payloadString);

    if (postResponse.statusCode != 302) throw Exception('Error logging in');

    String cookie = postResponse.headers['set-cookie']!;

    cookie = cookie.split('JSESSIONID=')[1];
    cookie = cookie.split(';')[0];
    if (cookie == '') throw Exception('No cookie found!');

    return 'JSESSIONID=$cookie;';
  }

  /// Makes an authenticated GET request with the given [session] to the
  /// resource located at [url] with the given [query] parameters.
  static Future<http.Response> getWithCookies(
      String baseUrl, Map<String, String> query, PrintServiceSession session) async {

    //TODO:? check if not logged in

    if (!baseUrl.contains('?')) {
      baseUrl += '?';
    }
    String url = baseUrl;
    query.forEach((key, value) {
      url += '$key=$value&';
    });
    if (query.isNotEmpty) {
      url = url.substring(0, url.length - 1);
    }

    final Map<String, String> headers = <String, String>{};
    headers['cookie'] = session.cookies;

    final http.Response response = await http.get(url.toUri(), headers: headers);
    if (response.statusCode == 200) {
      return response;
    } 
    /*
    else if (response.statusCode == 403 && !(await userLoggedIn(session))) { 
      // HTTP403 - Forbidden
      final bool reLoginSuccessful = await relogin(session);
      if (reLoginSuccessful) {
        headers['cookie'] = session.cookies;
        return http.get(url.toUri(), headers: headers);
      } else {
        onReloginFail();
        Logger().e('Login failed');
        return Future.error('Login failed');
      }*/
    else {
      return Future.error('HTTP Error ${response.statusCode}');
    }
  }
}
