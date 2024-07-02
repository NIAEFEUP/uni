import 'package:uni/model/entities/app_locale.dart';

class ExpiredCredentialsException implements Exception {
  ExpiredCredentialsException();
}

class InternetStatusException implements Exception {
  InternetStatusException(this.locale)
      : message = locale == AppLocale.en
            ? 'Check your internet connection'
            : 'Verifique sua conexão com a internet';

  final AppLocale locale;
  final String message;
}

class WrongCredentialsException implements Exception {
  WrongCredentialsException(this.locale)
      : message = locale == AppLocale.en
            ? 'Invalid credentials'
            : 'Credenciais inválidas';

  final AppLocale locale;
  final String message;
}
