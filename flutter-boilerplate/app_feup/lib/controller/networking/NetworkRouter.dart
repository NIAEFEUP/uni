import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:query_params/query_params.dart';

class NetworkRouter {
  void login(String user, String pass) async {
  final url = 'https://sigarra.up.pt/feup/pt/mob_val_geral.autentica';
  http.post(
    url,
    body: {
      "pv_login": user,
      "pv_password": pass
    }
  ).then( (response) {
    if (response.statusCode == 200) {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      profile(user);
    } else {
      print('Login request failed');
    }
  });
}

void profile(String user) {
  final URLQueryParams params = new URLQueryParams();
  params.append('pv_codigo', user);
  final url = 'https://sigarra.up.pt/feup/pt/mob_fest_geral.perfil?${params.toString()}';
  print('profile url is $url');
  http.get(url)
  .then( (response) {
    if (response.statusCode == 200) {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
    } else {
      print('Profile request failed');
    }
  });
}
}

