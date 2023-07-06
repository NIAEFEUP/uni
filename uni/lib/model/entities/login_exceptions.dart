class ExpiredCredentialsException implements Exception {
  ExpiredCredentialsException();
}

class InternetStatusException implements Exception {
  String message = 'Verifica a tua ligação à internet';
  InternetStatusException();
}

class WrongCredentialsException implements Exception {
  String message = 'Credenciais inválidas';
  WrongCredentialsException();
}
