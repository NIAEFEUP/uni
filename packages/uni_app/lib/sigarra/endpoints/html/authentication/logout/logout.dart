import 'package:uni/sigarra/options.dart';
import 'package:uni/sigarra/response.dart';

class Logout {
  const Logout();

  Future<SigarraResponse> call({
    FacultyRequestOptions? options,
  }) async {
    options = options ?? FacultyRequestOptions();

    final logoutUrl = options.baseUrl.resolve('vld_validacao.sair');
    final response = await options.client.get(logoutUrl);

    return SigarraResponse(success: response.statusCode == 200);
  }
}
