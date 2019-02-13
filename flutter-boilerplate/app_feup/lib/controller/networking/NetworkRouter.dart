import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:query_params/query_params.dart';

class NetworkRouter {
  final Map<String, dynamic> session = Map<String, dynamic>();

  void login(String user, String pass) async {
    final url = 'https://sigarra.up.pt/feup/pt/mob_val_geral.autentica';
    final response =
        await http.post(url, body: {"pv_login": user, "pv_password": pass});
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody['authenticated']) {
        session.clear();
        session['studentNumber'] = responseBody['codigo'];
        session['type'] = responseBody['tipo'];
        session['cookies'] = extractCookies(response.headers);
        getProfile();
      }
    } else {
      print('Login request failed');
    }
  }

  static List<String> extractCookies(response) {
    final List<String> res = List<String>();
    final String cookies = response['set-cookie'];
    if (cookies != null) {
      final List<String> rawCookies = cookies.split(',');
      for (var c in rawCookies) {
        res.add(Cookie.fromSetCookieValue(c).toString());
      }
    }
    return res;
  }

  void getProfile() async{
    final response = await getWithCookies(
      'https://sigarra.up.pt/feup/pt/mob_fest_geral.perfil?',
      {"pv_codigo": session['studentNumber']}
    );
    print(response.body);
  }

  Future<http.Response> getWithCookies(
      String baseUrl, Map<String, String> query) {
    final URLQueryParams params = new URLQueryParams();
    query.forEach((key, value) {
      params.append(key, value);
    });

    final url = baseUrl + params.toString();

    final Map<String, String> headers = Map<String, String>();
    headers['cookie'] = session['cookies'].join(';');

    return http.get(url, headers: headers);
  }
}
