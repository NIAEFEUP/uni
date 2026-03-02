import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uni/controller/networking/network_router.dart';

class BookThumbFetcher {
  Future<String?> fetchBookThumb(String isbn) async {
    final googleBooksFuture = _fetchFromGoogleBooks(isbn);
    final openLibraryFuture = _fetchFromOpenLibrary(isbn);

    final results = await Future.wait([googleBooksFuture, openLibraryFuture]);

    return results.firstWhere((result) => result != null, orElse: () => null);
  }

  Future<String?> _fetchFromGoogleBooks(String isbn) async {
    final googleBooksUrl = Uri.https(
      'www.googleapis.com',
      '/books/v1/volumes',
      {'q': 'isbn:$isbn'},
    );

    final response = await http.get(
      Uri.decodeComponent(googleBooksUrl.toString()).toUri(),
    );

    final body = json.decode(response.body);
    if (body is! Map<String, dynamic>) {
      return null;
    }

    final numBooks = body['totalItems'] as int? ?? 0;

    if (numBooks > 0) {
      final items = body['items'];
      if (items is List && items.isNotEmpty) {
        final bookInformation = items.first;
        if (bookInformation is Map<String, dynamic>) {
          final volumeInfo = bookInformation['volumeInfo'];
          if (volumeInfo is Map<String, dynamic>) {
            final imageLinks = volumeInfo['imageLinks'];
            if (imageLinks is Map<String, dynamic>) {
              return imageLinks['thumbnail']?.toString();
            }
          }
        }
      }
    }

    return null;
  }

  Future<String?> _fetchFromOpenLibrary(String isbn) async {
    final url = Uri.https('covers.openlibrary.org', '/b/isbn/$isbn-M.jpg');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final contentType = response.headers['content-type'];
      if (contentType != null && contentType.startsWith('image/')) {
        return url.toString();
      }
    }

    return null;
  }
}
