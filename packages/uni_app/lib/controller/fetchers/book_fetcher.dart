import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uni/controller/networking/network_router.dart';

class BookThumbFetcher {
  Future<String?> fetchBookThumb(String isbn) async {
    final googleBooksFuture = _fetchFromGoogleBooks(isbn);
    final openLibraryFuture = _fetchFromOpenLibrary(isbn);

    final completer = Completer<String?>();

    googleBooksFuture.then((result) {
      if (result != null && !completer.isCompleted) {
        completer.complete(result);
      }
    });

    openLibraryFuture.then((result) {
      if (result != null && !completer.isCompleted) {
        completer.complete(result);
      }
    });

    Future.wait([googleBooksFuture, openLibraryFuture]).then((results) {
      if (!completer.isCompleted) {
        completer.complete(null);
      }
    });

    return completer.future;
  }

  Future<String?> _fetchFromGoogleBooks(String isbn) async {
    final googleBooksUrl = Uri.https(
      'www.googleapis.com',
      '/books/v1/volumes',
      {'q': 'isbn:$isbn'},
    );

    final response =
        await http.get(Uri.decodeComponent(googleBooksUrl.toString()).toUri());

    final numBooks = ((json.decode(response.body)
            as Map<String, dynamic>)['totalItems'] as int)
        .toInt();

    if (numBooks > 0) {
      final bookInformation = ((json.decode(response.body)
              as Map<String, dynamic>)['items'] as List<dynamic>)
          .first as Map<String, dynamic>;
      final thumbnailURL =
          ((bookInformation['volumeInfo'] as Map<String, dynamic>)['imageLinks']
              as Map<String, dynamic>)['thumbnail'];
      return thumbnailURL.toString();
    }

    return null;
  }

  Future<String?> _fetchFromOpenLibrary(String isbn) async {
    final url = Uri.https('covers.openlibrary.org', '/b/isbn/$isbn-M.jpg');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final contentType = response.headers['content-type'];
        if (contentType != null && contentType.startsWith('image/')) {
          return url.toString();
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
