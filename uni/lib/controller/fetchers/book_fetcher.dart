import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uni/model/entities/course_units/sheet.dart';

class BookThumbFetcher {
  Future<Image> fetchBookThumb(String isbn) async {
    final url = Uri.https('openlibrary.org', '/api/books',
        {'bibkeys': 'ISBN:$isbn', 'format': 'json', 'jscmd': 'data'});

    final response = await http.get(url);

    final data =
        json.decode(response.body)['ISBN:$isbn'] as Map<String, dynamic>;

    return Image(image: NetworkImage(data['cover']['medium'].toString()));
  }
}
