import 'dart:async';

import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;
import 'package:uni/sigarra/endpoint.dart';
import 'package:uni/sigarra/endpoints/html/home/response.dart';
import 'package:uni/sigarra/options.dart';

class Home extends Endpoint<HomeResponse> {
  const Home({this.options});

  final FacultyRequestOptions? options;

  @override
  Future<HomeResponse> call() async {
    final options = this.options ?? FacultyRequestOptions();

    final loginUrl = options.baseUrl.resolve('web_page.inicial');

    final response = await options.client.get(loginUrl);

    return _parse(response);
  }

  Future<HomeResponse> _parse(http.Response response) async {
    if (response.statusCode != 200) {
      return const HomeResponse(success: false);
    }

    final document = html_parser.parse(response.body);

    final authenticatedHeader = document.querySelector('.autenticado');
    if (authenticatedHeader == null) {
      return const HomeSuccessfulResponse(authenticated: false);
    }

    final photo = authenticatedHeader.querySelector('.fotografia img');
    final photoUrl = photo == null
        ? null
        : Uri.tryParse(photo.attributes['src'] ?? '');

    return HomeAuthenticatedResponse(photoUrl: photoUrl);
  }
}
