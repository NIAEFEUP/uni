import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uni/controller/networking/network_router.dart';

class BookThumbFetcher {
  Future<String> fetchBookThumb(String isbn) async {
    final url = Uri.https(
      'www.googleapis.com',
      '/books/v1/volumes',
      {'q': '+isbn:$isbn'},
    );

    final response =
        await http.get(Uri.decodeComponent(url.toString()).toUri());

    final bookInformation = ((json.decode(response.body)
            as Map<String, dynamic>)['items'] as List<dynamic>)
        .first as Map<String, dynamic>;

    final thumbnailURL =
        ((bookInformation['volumeInfo'] as Map<String, dynamic>)['imageLinks']
            as Map<String, dynamic>)['thumbnail'];

    return thumbnailURL.toString();
  }
}
