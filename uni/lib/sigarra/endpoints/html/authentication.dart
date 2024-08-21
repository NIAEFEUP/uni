import 'package:uni/sigarra/options.dart';

Future<void> logout({
  FacultyRequestOptions? options,
}) async {
  options = options ?? FacultyRequestOptions();

  final logoutUrl = options.baseUrl.resolve('vld_validacao.sair');
  final response = await options.client.get(logoutUrl);

  if (response.statusCode == 200) {
    return;
  }

  throw Exception('Failed to logout from SIGARRA');
}
