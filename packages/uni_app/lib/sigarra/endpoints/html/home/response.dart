import 'package:uni/sigarra/response.dart';

class HomeResponse extends EndpointResponse {
  const HomeResponse({required super.success});

  HomeSuccessfulResponse asSuccessful() => this as HomeSuccessfulResponse;
}

class HomeSuccessfulResponse extends HomeResponse {
  const HomeSuccessfulResponse({required this.authenticated})
    : super(success: true);

  final bool authenticated;

  HomeAuthenticatedResponse asAuthenticated() =>
      this as HomeAuthenticatedResponse;
}

class HomeAuthenticatedResponse extends HomeSuccessfulResponse {
  const HomeAuthenticatedResponse({required this.photoUrl})
    : super(authenticated: true);

  final Uri? photoUrl;
}
