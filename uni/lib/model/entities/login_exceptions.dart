import 'package:uni/generated/l10n.dart';
import 'package:uni/main.dart';

class ExpiredCredentialsException implements Exception {
  ExpiredCredentialsException();
}

class InternetStatusException implements Exception {
  InternetStatusException();
  String message = S.of(MyApp.navigatorKey.currentContext!).check_internet;
}

class WrongCredentialsException implements Exception {
  WrongCredentialsException();
  String message = S.of(MyApp.navigatorKey.currentContext!).invalid_credentials;
}
