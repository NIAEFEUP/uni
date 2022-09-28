import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:gsheets/gsheets.dart';
import 'package:redux/redux.dart';
import 'package:uni/controller/parsers/parser_library_occupation.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/library_occupation.dart';

/// Fetch the library occupation from Google Sheets
class LibraryOccupationFetcherSheets {
  Future<LibraryOccupation> getLibraryOccupationFromSheets(
      Store<AppState> store) async {
    const sheetId = '1gZRbEX4y8vNW7vrl15FCdAQ3pVNRJw_uRZtVL6ORP0g';

    try {
      final String key = await loadApiKey();
      final gSheets = GSheets(key);
      final ss = await gSheets.spreadsheet(sheetId);

      final sheet = ss.worksheetByTitle('MANUAL');

      return getLibraryOccupationFromSheet(sheet!);
    } catch (FlutterError) {
      return LibraryOccupation(0, 0);
    }
  }

  Future<Map<String, dynamic>> parseJsonFromAssets(String assetsPath) async {
    return rootBundle
        .loadString(assetsPath)
        .then((jsonStr) => jsonDecode(jsonStr));
  }

  Future<String> loadApiKey() async {
    final Map<String, dynamic> dataMap =
        await parseJsonFromAssets('assets/env/env.json');
    return dataMap['api_key'];
  }
}
