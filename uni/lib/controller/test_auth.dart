import 'package:flutter_dotenv/flutter_dotenv.dart';
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
        scopes: ['openid', 'profile', 'email', 'offline_access'],
      );

      await invoke(_flow.authenticationUri);
    } catch (e) {
      Logger().e(e);
      await closeInAppWebView();
    }
  }

  static Future<void> doTheRest(Uri uri) async {
    final credential = await _flow.callback(uri.queryParameters);

    final userInfo = await credential.getUserInfo();

    Logger().d((await credential.getTokenResponse()).expiresIn);
    Logger().d((await credential.getTokenResponse()).refreshToken);

    Logger().d(userInfo.toJson());

    //do the rest of the login process

    //use token to get cookie from serviço de autenticação OIDC do SIGARRA
    //const userinfoEndpoint = 'https://example.com/userinfo';
    //final response = await http.get(
    //  Uri.parse(userinfoEndpoint),
    //  headers: <String, String>{
    //    'Authorization': 'Bearer ${c.idToken}',
    //    'Content-Type': 'application/json',
    //  },
    //);
  }
}
