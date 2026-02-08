import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:uni/model/entities/news.dart';

Future<List<News>?> fetchNews() async {
  try {
    final response = await http
        .get(Uri.parse('https://noticias.up.pt/wp-json/wp/v2/posts'))
        .timeout(const Duration(seconds: 6));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final body = jsonDecode(response.body) as List<dynamic>;
      return body
          .map((dynamic item) => News.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(response.statusCode);
    }
  } catch (err) {
    throw Exception(err);
  }
}
