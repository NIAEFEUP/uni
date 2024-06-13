import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uni/controller/networking/network_router.dart';

class BookThumbFetcher {
  Future<Image> fetchBookThumb(String isbn) async {
    final url = Uri.https(
        'www.googleapis.com', '/books/v1/volumes', {'q': '+isbn:$isbn'});

    final response =
        await http.get(Uri.decodeComponent(url.toString()).toUri());

    final bookInformation = ((json.decode(response.body)
            as Map<String, dynamic>)['items'] as List<dynamic>)
        .first as Map<String, dynamic>;

    final thumbnail =
        ((bookInformation['volumeInfo'] as Map<String, dynamic>)['imageLinks']
            as Map<String, dynamic>)['thumbnail'];

    return Image(image: NetworkImage(thumbnail.toString()));
  }
}
