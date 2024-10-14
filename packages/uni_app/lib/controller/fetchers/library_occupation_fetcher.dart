import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/model/entities/library_occupation.dart';

/// Fetch the library occupation from Google Sheets
class LibraryOccupationFetcher {
  String baseUrl = 'https://webapi.affluences.com/api/fillRate?';

  static const List<Tuple2<String, int>> floorMaxSeats = [
    Tuple2('BruV6IlujdwAe1', 72),
    Tuple2('cEhyzJZvC5nHSr', 114),
    Tuple2('iceVfgwZWaZRhV', 114),
    Tuple2('1yLPz9X0CNsg27', 114),
    Tuple2('keu1j5zERlQn90', 40),
    Tuple2('bY7K1v43HiAq55', 90),
  ];

  Future<LibraryOccupation> getLibraryOccupation() async {
    final libraryOccupation = LibraryOccupation(0, 0);

    await Future.wait(
      floorMaxSeats.mapIndexed((i, entry) async {
        final url = Uri.parse(baseUrl).replace(
          queryParameters: {
            'token': entry.item1,
          },
        );

        final response = await http.get(url);

        final floorOccupation =
            processFloorOccupation(response, entry.item2, i);

        libraryOccupation.addFloor(floorOccupation);
      }),
    );

    return libraryOccupation;
  }

  FloorOccupation processFloorOccupation(
    Response response,
    int floorCapacity,
    int floor,
  ) {
    final responseBody = jsonDecode(response.body) as Map<String, dynamic>;

    final floorOccupation = responseBody['progress'] as int? ?? 0;

    return FloorOccupation(
      floor + 1,
      (floorOccupation * floorCapacity / 100).round(),
      floorCapacity,
    );
  }
}
