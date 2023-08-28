class ExpiredCredentialsException implements Exception {
  ExpiredCredentialsException();
}

class InternetStatusException implements Exception {
  InternetStatusException();
  String message = 'Verifica a tua ligação à internet';
}

class WrongCredentialsException implements Exception {
  WrongCredentialsException();
  String message = 'Credenciais inválidas';
}
