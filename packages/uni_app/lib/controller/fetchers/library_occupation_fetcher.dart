import 'package:uni/controller/fetchers/session_dependant_fetcher.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_library_occupation.dart';
import 'package:uni/controller/session/session.dart';
import 'package:uni/model/entities/library_occupation.dart';

/// Fetch the library occupation from Google Sheets
class LibraryOccupationFetcherSheets implements SessionDependantFetcher {
  @override
  List<String> getEndpoints(Session session) {
    const baseUrl = 'https://docs.google.com/spreadsheets/d/';
    const sheetId = '1gZRbEX4y8vNW7vrl15FCdAQ3pVNRJw_uRZtVL6ORP0g';
    const url =
        '$baseUrl$sheetId/gviz/tq?tqx=out:json&sheet=MANUAL&range=C2:E7&tq=SELECT+C,E';
    return [url];
  }

  Future<LibraryOccupation> getLibraryOccupationFromSheets(
    Session session,
  ) async {
    final url = getEndpoints(session)[0];
    final response = NetworkRouter.getWithCookies(url, {}, session);
    final occupation = await response.then(parseLibraryOccupationFromSheets);
    return occupation;
  }
}
