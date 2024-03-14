import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:openid_client/openid_client.dart';
import 'package:url_launcher/url_launcher.dart';

class FederatedLogin {
  static late Flow _flow;

  static Future<void> invoke(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
    } else {
      Logger().e('Could not launch $uri');
    }
  }

  static Future<void> tryAuthenticate() async {
    try {
      final realm = dotenv.env['REALM'] ?? '';
      final issuer = await Issuer.discover(Uri.parse(realm));
      final client = Client(
        issuer,
        dotenv.env['CLIENT_ID'] ?? '',
        clientSecret: dotenv.env['CLIENT_SECRET'],
      );

      _flow = Flow.authorizationCode(
        client,
        redirectUri: Uri.parse('pt.up.fe.ni.uni://auth'),
        scopes: ['openid', 'profile', 'email', 'offline_access', 'audience'],
      );

      await invoke(_flow.authenticationUri);
    } catch (e) {
      Logger().e(e);
      await closeInAppWebView();
    }
  }

  static Future<Map<String, dynamic>> getSigarraCokie(Uri uri) async {
    final credential = await _flow.callback(uri.queryParameters);

    final userInfo = await credential.getUserInfo();

    final token = (await credential.getTokenResponse()).accessToken;

    const sigarraTokenEndpoint = 'https://sigarra.up.pt/auth/oidc/token';
    final response = await http.get(
      Uri.parse(sigarraTokenEndpoint),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to get token from SIGARRA');
    }

    return {'response': response, 'userInfo': userInfo};
  }
}
