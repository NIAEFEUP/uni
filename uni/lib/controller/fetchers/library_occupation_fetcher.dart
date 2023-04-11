import 'package:http/http.dart';
import 'package:uni/controller/fetchers/session_dependant_fetcher.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_library_occupation.dart';
import 'package:uni/model/entities/library_occupation.dart';
import 'package:uni/model/entities/session/sigarra_session.dart';

/// Fetch the library occupation from Google Sheets
class LibraryOccupationFetcherSheets implements SessionDependantFetcher {
  @override
  List<String> getEndpoints(Session session) {
    // TODO:: Implement parsers for all faculties
    // and dispatch for different fetchers
    const String baseUrl = 'https://docs.google.com/spreadsheets/d/';
    const String sheetId = '1gZRbEX4y8vNW7vrl15FCdAQ3pVNRJw_uRZtVL6ORP0g';
    const String url =
        '$baseUrl$sheetId/gviz/tq?tqx=out:json&sheet=MANUAL&range=C2:E7&tq=SELECT+C,E';
    return [url];
  }

  Future<LibraryOccupation> getLibraryOccupationFromSheets(
      Session session) async {
    final String url = getEndpoints(session)[0];
    final Future<Response> response =
        NetworkRouter.getWithCookies(url, {}, session);
    final LibraryOccupation occupation = await response
        .then((response) => parseLibraryOccupationFromSheets(response));
    return occupation;
  }
}
