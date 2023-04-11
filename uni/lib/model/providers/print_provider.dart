import 'package:logger/logger.dart';
import 'package:uni/controller/networking/print_service.dart';
import 'package:uni/model/entities/session/print_service_session.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:http/http.dart' as http;

class PrintProvider extends StateProviderNotifier {
  PrintServiceSession _session = PrintServiceSession();

  bool get isAutenhicated => _session.authenticated;

  Future<bool> loginIntoPrintService(String email, String password, bool keepSignedIn) async {
    try {
      final String newCookie =
          await PrintService.getCookie(email, password);

      _session = PrintServiceSession(
          authenticated: true,
          cookies: newCookie,
          persistentSession: keepSignedIn);

      notifyListeners();
      return true;
    } catch (e) {
      _session = PrintServiceSession();

      Logger().e('Login into Print Service failed: $e');
      return false;
    }
  }

  updateAuthenticatedInPrintService() async {
    if (_session.cookies.contains('JSESSIONID')) {
      const String url = 'https://print.up.pt/app?service=page/UserSummary';
      final http.Response response =
          await PrintService.getWithCookies(url, {}, _session);

      if (response.statusCode == 200) {
        _session.authenticated = true;
        notifyListeners();
        return;
      }
    }
    // not authenticated
    _session.authenticated = false;
    notifyListeners();
  }
}
