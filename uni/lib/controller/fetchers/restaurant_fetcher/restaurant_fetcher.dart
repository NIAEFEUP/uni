import 'package:http/http.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/model/entities/session.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_restaurants.dart';

/// Class for fetching the menu
class RestaurantFetcher {
  String spreadSheetUrl =
      'https://docs.google.com/spreadsheets/d/1TJauM0HwIf2RauQU2GmhdZZ1ZicFLMHuBkxWwVOw3Q4';
  String jsonEndpoint = '/gviz/tq?tqx=out:json&range=A:D&sheet=';

  // List the Sheets in the Google Sheets Document
  List<String> sheets = ['Cantina de Engenharia'];

  // Generate the endpoints list based on the list of sheets
  List<Tuple2<String, String?>> getEndpointsAndRestaurantNames() {
    final List<Tuple2<String, String?>> urls = [
      Tuple2('${NetworkRouter.getBaseUrl('feup')}CANTINA.EMENTASHOW', null)
    ];

    urls.addAll(sheets
        .map((sheet) => Tuple2(
            spreadSheetUrl + jsonEndpoint + Uri.encodeComponent(sheet), sheet))
        .toList());

    return urls.reversed.toList();
  }

  Future<List<Restaurant>> getRestaurants(Session session) async {
    final List<Restaurant> restaurants = [];
    for (var endpointAndName in getEndpointsAndRestaurantNames()) {
      final Future<Response> response =
          NetworkRouter.getWithCookies(endpointAndName.item1, {}, session);

      restaurants.addAll(await response.then((response) {
        final bool isGSheets = endpointAndName.item2 != null;
        if (isGSheets) {
          return getRestaurantsFromGSheets(response, endpointAndName.item2!);
        } else {
          return getRestaurantsFromHtml(response);
        }
      }));
    }

    return restaurants;
  }
}
