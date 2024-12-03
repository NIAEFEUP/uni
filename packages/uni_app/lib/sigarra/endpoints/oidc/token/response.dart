import 'dart:io';

import 'package:uni/sigarra/response.dart';

class TokenResponse extends EndpointResponse {
  const TokenResponse({required super.success});

  TokenSuccessfulResponse asSuccessful() => this as TokenSuccessfulResponse;
  TokenFailedResponse asFailed() => this as TokenFailedResponse;
}

class TokenFailedResponse extends TokenResponse {
  const TokenFailedResponse() : super(success: false);
}

class TokenSuccessfulResponse extends TokenResponse {
  const TokenSuccessfulResponse({required this.cookies}) : super(success: true);

  final List<Cookie> cookies;
}
