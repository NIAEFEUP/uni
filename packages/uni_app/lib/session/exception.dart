enum AuthenticationExceptionType {
  wrongCredentials,
  expiredCredentials,
  other,
}

class AuthenticationException implements Exception {
  const AuthenticationException(
    this.message, [
    this.type = AuthenticationExceptionType.other,
  ]);

  final String message;
  final AuthenticationExceptionType type;

  @override
  String toString() => 'AuthenticationException($message, $type)';
}
