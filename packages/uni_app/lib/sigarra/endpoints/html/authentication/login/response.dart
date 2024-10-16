import 'package:uni/sigarra/response.dart';

class LoginResponse extends EndpointResponse {
  const LoginResponse({required super.success});

  LoginFailedResponse asFailed() => this as LoginFailedResponse;
}

enum LoginFailureReason {
  serverError,
  wrongCredentials,
  expiredCredentials,
  blockedAccount,
  alreadyLoggedIn,
  unknown,
}

class LoginFailedResponse extends LoginResponse {
  const LoginFailedResponse({required this.reason}) : super(success: false);

  final LoginFailureReason reason;
}
