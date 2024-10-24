import 'package:uni/http/utils.dart';
import 'package:uni/sigarra/endpoint.dart';
import 'package:uni/sigarra/endpoints/oidc/token/response.dart';
import 'package:uni/sigarra/options.dart';

class Token extends Endpoint<TokenResponse> {
  const Token({this.options});

  final SigarraRequestOptions? options;

  /// Returns the cookies for SIGARRA using the OIDC token.
  ///
  /// The client must be authorized to make this request.
  @override
  Future<TokenResponse> call() async {
    final options = this.options ?? SigarraRequestOptions();

    final tokenUrl = options.baseUrl.resolve('auth/oidc/token');
    final response = await options.client.get(
      tokenUrl,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return TokenSuccessfulResponse(cookies: extractCookies(response));
    }

    return const TokenFailedResponse();
  }
}
