import 'package:http/http.dart' as http;
import 'package:uni/sigarra/options.dart';

Future<http.Response> login({
  required String username,
  required String password,
  FacultyRequestOptions? options,
}) {
  options = options ?? FacultyRequestOptions();

  final loginUrl = options.baseUrl.resolve('mob_val_geral.autentica');

  return options.client.post(
    loginUrl,
    body: {
      'pv_login': username,
      'pv_password': password,
    },
  );
}
