import 'dart:io';

import 'package:uni/sigarra/response.dart';

abstract class LoginResponse extends EndpointResponse {
  const LoginResponse({required super.success});

  LoginSuccessfulResponse asSuccessful() => this as LoginSuccessfulResponse;
  LoginFailedResponse asFailed() => this as LoginFailedResponse;
}

class LoginSuccessfulResponse extends LoginResponse {
  const LoginSuccessfulResponse({required this.username, required this.cookies})
      : super(success: true);

  final String username;
  final List<Cookie> cookies;
}

enum LoginFailureReason {
  serverError,
  unknown,
}

class LoginFailedResponse extends LoginResponse {
  const LoginFailedResponse({required this.reason}) : super(success: false);

  final LoginFailureReason reason;
}
