import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:gsheets/gsheets.dart';
import 'package:http/http.dart';
import 'package:redux/redux.dart';
import 'package:uni/controller/fetchers/session_dependant_fetcher.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_library_occupation.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/library_occupation.dart';
import 'package:uni/model/entities/session.dart';

/// Fetch the library occupation from Google Sheets
class LibraryOccupationFetcherSheets implements SessionDependantFetcher {
  @override
  List<String> getEndpoints(Session session) {
    // TO DO: Implement parsers for all faculties
    // and dispatch for different fetchers
    const String base_url = 'https://docs.google.com/spreadsheets/d/';
    const String sheet_id = '1gZRbEX4y8vNW7vrl15FCdAQ3pVNRJw_uRZtVL6ORP0g';
    const String url = '$base_url$sheet_id/gviz/tq?tqx=out:json';
    return [url];
  }

  Future<LibraryOccupation> getLibraryOccupationFromSheets(
      Store<AppState> store) async {
    final Session session = store.state.content['session'];
    final String url = getEndpoints(session)[0];
    final Future<Response> response =
        NetworkRouter.getWithCookies(url, {}, session);
    final LibraryOccupation occupation = await response
        .then((response) => parseLibraryOccupationFromSheets(response));
    return occupation;
  }
}
