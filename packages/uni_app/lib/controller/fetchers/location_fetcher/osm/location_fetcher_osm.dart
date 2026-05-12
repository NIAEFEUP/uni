import 'package:http/http.dart' as http;
import 'package:uni/controller/fetchers/location_fetcher/location_fetcher.dart';
import 'package:uni/controller/fetchers/location_fetcher/osm/osm_parser.dart';
import 'package:uni/model/entities/indoor_floor_plan.dart';
import 'package:uni/model/entities/location_group.dart';

class LocationFetcherOSM extends LocationFetcher {
  LocationFetcherOSM(super.facultyConfig) {
    _parser = OSMParser(facultyConfig);
  }

  late final OSMParser _parser;
  Future<http.Response>? _response;

  @override
  Future<List<LocationGroup>> getLocations() async {
    try {
      final response = await (_response ??= _queryOverpass());
      return _parser.parseLocations(response);
    } catch (err) {
      _response = null;
      throw Exception('[OSM] Failed to fetch locations: $err');
    }
  }

  @override
  Future<List<IndoorFloorPlan>> getIndoorFloorPlans() async {
    try {
      final response = await (_response ??= _queryOverpass());
      return _parser.parseIndoorData(response);
    } catch (err) {
      _response = null;
      throw Exception('[OSM] Failed to fetch indoor data: $err');
    }
  }

  Future<http.Response> _queryOverpass() async {
    const overpassUrl = 'https://overpass-api.de/api/interpreter';
    const maxRetries = 10;

    final bounds = facultyConfig.bounds;
    final query =
        '''
      [out:json][timeout:25];
      (
        // Get ${facultyConfig.name} buildings
        way["building"]["name"~"${facultyConfig.name}|Faculdade"](${bounds.minLat},${bounds.minLon},${bounds.maxLat},${bounds.maxLon});
        
        // Get indoor features
        node["indoor"](${bounds.minLat},${bounds.minLon},${bounds.maxLat},${bounds.maxLon});
        way["indoor"](${bounds.minLat},${bounds.minLon},${bounds.maxLat},${bounds.maxLon});
        
        // Get amenities
        node["amenity"](${bounds.minLat},${bounds.minLon},${bounds.maxLat},${bounds.maxLon});
        way["amenity"](${bounds.minLat},${bounds.minLon},${bounds.maxLat},${bounds.maxLon});
      );
      out body;
      >;
      out skel qt;
    ''';

    for (var attempt = 0; attempt < maxRetries; attempt++) {
      try {
        final response = await http
            .post(
              Uri.parse(overpassUrl),
              headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'User-Agent': 'uni_app/map_fetcher (uni)',
              },
              body: 'data=$query',
            )
            .timeout(const Duration(seconds: 90));

        if (response.statusCode == 200) {
          return response;
        }

        if (response.statusCode == 504 && attempt < maxRetries - 1) {
          continue;
        }

        throw Exception('[OSM] Overpass API returned ${response.statusCode}');
      } on Exception {
        if (attempt >= maxRetries - 1) {
          rethrow;
        }
      }
    }

    throw Exception('[OSM] Overpass API failed after $maxRetries retries');
  }
}
