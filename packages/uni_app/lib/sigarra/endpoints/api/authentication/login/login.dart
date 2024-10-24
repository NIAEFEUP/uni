import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:uni/http/utils.dart';
import 'package:uni/sigarra/endpoints/api/authentication/login/json.dart';
import 'package:uni/sigarra/endpoints/api/authentication/login/response.dart';
import 'package:uni/sigarra/options.dart';

class Login {
  const Login({
    required this.username,
    required this.password,
    this.options,
  });

  final String username;
  final String password;
  final FacultyRequestOptions? options;

  Future<LoginResponse> call() async {
    final options = this.options ?? FacultyRequestOptions();

    final loginUrl = options.baseUrl.resolve('mob_val_geral.autentica');

    final response = await options.client.post(
      loginUrl,
      body: {
        'pv_login': username,
        'pv_password': password,
      },
    );

    return _parse(response);
  }

  Future<LoginResponse> _parse(http.Response response) async {
    if (response.statusCode != 200) {
      return const LoginFailedResponse(
        reason: LoginFailureReason.serverError,
      );
    }

    final responseBody = LoginJsonResponse.fromJson(
      json.decode(response.body) as Map<String, dynamic>,
    );

    if (responseBody.authenticated) {
      return LoginSuccessfulResponse(
        username: responseBody.username,
        cookies: extractCookies(response),
      );
    }

    return const LoginFailedResponse(
      reason: LoginFailureReason.unknown,
    );
  }
}
