import 'package:uni/sigarra/endpoint.dart';
import 'package:uni/sigarra/options.dart';
import 'package:uni/sigarra/response.dart';

class Logout extends Endpoint {
  const Logout({
    this.options,
  });

  final FacultyRequestOptions? options;

  @override
  Future<EndpointResponse> call() async {
    final options = this.options ?? FacultyRequestOptions();

    final logoutUrl = options.baseUrl.resolve('vld_validacao.sair');
    final response = await options.client.get(logoutUrl);

    return EndpointResponse(success: response.statusCode == 200);
  }
}
